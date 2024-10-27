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

        # Iterate over all abilities to set them on the character
        all_special_abilities.each do |ability|
          # Expertise limit for choosing options
          expertise_limit = ability['Expertise'] ? ability['Expertise'].split('/').first.to_i : 0

          if ability['SkList']
            options = ability['SkList'].split(',').map(&:strip)

            if options.size == 1
              # Automatically set the single option
              self.choices = options.first
              RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
              client.emit_success "The option '#{self.choices}' has been automatically set for the ability '#{ability['Name']}'."
            else
              # Display available options if multiple choices are available
              client.emit_ooc "Available options for '#{ability['Name']}': #{options.join(', ')}"
              client.emit_ooc "You can select up to #{expertise_limit} options."
            end
          else
            # No options to set, just add the ability
            RecursiveRealms.set_special_ability_choices(ability, nil, expertise_limit, enactor, client, traits)
            client.emit_success "The ability '#{ability['Name']}' has been set."
          end
        end
      end
    end
  end
end
