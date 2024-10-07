module AresMUSH
    module RecursiveRealms
      class SetSACmd
        include CommandHandler
  
        attr_accessor :ability_name, :choices
  
        def parse_args
          split_switch = RecursiveRealms.multi_split_command(@cmd)
          self.ability_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the special ability
          self.choices = split_switch.length > 3 ? split_switch[3] : nil # The user choices, if provided
        end
  
        def handle
          # Retrieve character traits
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
  
          # Retrieve special abilities from the current tier and lower tiers
          all_special_abilities = RecursiveRealms.get_all_special_abilities_for_tier_and_below(chartype, traits.tier)
  
          # If no ability name is provided, show unset abilities with options
          if self.ability_name.nil? || self.ability_name.empty?
            RecursiveRealms.list_unset_abilities_with_options(all_special_abilities, enactor, client)
            return
          end
  
          # Find the ability by name
          ability = all_special_abilities.find { |a| a['Name'].downcase == self.ability_name.downcase }
          if ability.nil?
            client.emit_failure "Special Ability '#{self.ability_name}' not found."
            return
          end
  
          # Determine the expertise limit for options selection
          expertise_limit = ability['Expertise'] ? ability['Expertise'].split('/').first.to_i : 0
  
          # If no choices are provided, display available options and how many can be chosen
          if self.choices.nil? || self.choices.empty?
            RecursiveRealms.list_unset_abilities_with_options([ability], enactor, client)
            return
          end
  
          # Set the selected choices for the ability
          RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
        end
      end
    end
  end