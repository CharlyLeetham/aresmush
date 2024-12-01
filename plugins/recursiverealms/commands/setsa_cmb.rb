module AresMUSH
  module RecursiveRealms
    class SetSACmd
      include CommandHandler

      attr_accessor :ability_name, :choices

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.ability_name = split_switch[2] if split_switch.length > 2
        self.choices = split_switch[3] if split_switch.length > 3
      end

      def handle

        client.emit_ooc "Ability_name: #{self.ability_name}, Choices: #{self.choices}"
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end

        # Retrieve the character type from the YAML configuration
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in configuration."
          return
        end

        # Get all special abilities for the character's current and lower tiers
        all_special_abilities = RecursiveRealms.get_all_special_abilities_for_tier_and_below(chartype, traits.tier)

        client.emit_ooc "#{all_special_abilities}"

          # If no ability name is provided, list all available special abilities
        if self.ability_name.nil? || self.ability_name.strip.empty?
          if all_special_abilities.empty?
            client.emit_ooc "No special abilities are available for your character."
          else
            ability_list = all_special_abilities.map { |ability| ability['Name'] }.join(', ')
            client.emit_ooc "Available special abilities: #{ability_list}"
          end
          return
        end

        # Find the ability by name
        ability = all_special_abilities.find { |a| a['Name'].casecmp(self.ability_name).zero? }

        if ability.nil?
          client.emit_failure "Special Ability '#{self.ability_name}' not found."
          return
        end        

        # Expertise limit for choosing options
        expertise_limit = ability['Expertise'] ? ability['Expertise'].split('/').first.to_i : 0

        # Handle case where the ability has options
        if ability['SkList']
          options = ability['SkList'].split(',').map(&:strip)

          if options.size == 1
            # Automatically set the single option
            self.choices = options.first
            RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
            client.emit_success "The option '#{self.choices}' has been automatically set for the ability '#{self.ability_name}'."
          elsif self.choices.nil?
            # Display available options if no choices are provided
            client.emit_ooc "Available options for '#{self.ability_name}': #{options.join(', ')}"
            client.emit_ooc "You can select up to #{expertise_limit} options."
          else
            # Set the selected choices for the ability
            RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
          end
        else
          # No options to set, just add the ability
          RecursiveRealms.set_special_ability_choices(ability, nil, expertise_limit, enactor, client, traits)
          client.emit_success "The ability '#{self.ability_name}' has been set."
        end        
      end
    end
  end
end