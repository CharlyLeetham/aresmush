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
  
          # If no ability name is provided, show all special abilities, highlighting what's already set
          if self.ability_name.nil?
            RecursiveRealms.new_list_all_special_abilities(all_special_abilities, enactor, client, traits)
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
  
          # If no choices are provided, display available options and how many can be chosen
          if self.choices.nil?
            RecursiveRealms.new_list_all_special_abilities([ability], enactor, client, traits)
            return
          end
  
          # Set the selected choices for the ability
          RecursiveRealms.set_special_ability_choices(ability, self.choices, expertise_limit, enactor, client, traits)
        end
      end
    end
  end