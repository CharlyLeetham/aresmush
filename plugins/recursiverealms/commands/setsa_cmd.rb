module AresMUSH
  module RecursiveRealms
    class SetSACmd
      include CommandHandler

      attr_accessor :ability_name, :choices

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)

        # Ensure we don't raise errors when not enough arguments are passed
        self.ability_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the special ability
        self.choices = split_switch.length > 3 ? split_switch[3] : nil # The user choices, if provided
      end

      def handle
        client.emit_ooc "#{ability_name}, #{choices}"

        # Retrieve character type and tier from their traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end        

        # Retrieve the special abilities from the YAML based on character type and tier
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in configuration."
          return
        end

        tier_key = "Tier #{traits.tier}"
        special_abilities = chartype['Tiers'][tier_key]['Special Abilities']

        # If no ability name is given, show a list of abilities with SkList options that haven't been set
        if self.ability_name.nil? || self.ability_name.empty?
          RecursiveRealms.list_unset_abilities_with_options(special_abilities, enactor, client)
          return
        end

        # Find the ability by name
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

        # Set the selected choices for the ability
        RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
      end
    end
  end
end
