module AresMUSH
  module RecursiveRealms
    class SetSACmd
      include CommandHandler

      attr_accessor :ability_name, :choices

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)

        # Ensure we don't raise errors when not enough arguments are passed
        self.ability_name = split_switch[2] # The name of the special ability
        self.choices = split_switch.length > 2 ? split_switch[3] : nil # The user choices, if provided
      end

      def handle
        client.emit_ooc "#{ability_name}, #{choices}"

        # Retrieve character type and tier from their traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end        

        # Retrieve the special ability from the YAML based on character type and tier
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in configuration."
          return
        end        
        tier_key = "Tier #{traits.tier}"
        special_abilities = chartype['Tiers'][tier_key]['Special Abilities']
        ability = special_abilities.find { |a| a['Name'].downcase == self.ability_name.downcase }

        if ability.nil?
          client.emit_failure "Special Ability '#{self.ability_name}' not found."
          return
        end

        # Determine how many options can be chosen based on the Expertise value
        expertise_limit = ability['Expertise'].split('/').first.to_i
        # If no choices provided, display the available options and how many can be chosen
        if self.choices.nil? || self.choices.empty?
          available_options = ability['SkList']
          client.emit_ooc "You need to select options for #{ability['Name']}. You can choose up to #{expertise_limit} options."
          client.emit_ooc "Available options: #{available_options}"
          client.emit_ooc "Use the command rr/set/#{ability['Name']}/choice1,choice2"
          return
        end

        # Split and validate user choices
        selected_choices = self.choices.split(",").map(&:strip)
        if selected_choices.size > expertise_limit
          client.emit_failure "You can only choose up to #{expertise_limit} options for #{ability['Name']}. You selected #{selected_choices.size}."
          return
        end

        client.emit_ooc "Here"
        # Update or create the ability record in the database for the character
        existing_ability = enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }

        client.emit_ooc "Hello: #{existing_ability.inspect}"        
        if existing_ability
          existing_ability.update(sklist: selected_choices.join(", "))
        else
          RRSpecialAbilities.create(
            character: enactor,
            name: ability['Name'],
            tier: traits.tier,
            type: ability['Type'],
            expertise: ability['Expertise'],
            sklist: selected_choices.join(", ")
          )
        end
        client.emit_success "You have selected: #{selected_choices.join(", ")} for #{ability['Name']}."
      end
    end
  end
end
