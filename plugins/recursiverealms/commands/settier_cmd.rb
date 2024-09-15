module AresMUSH
    module RecursiveRealms
      class SetTierCmd
        include CommandHandler
  
        attr_accessor :topcmd, :type, :value, :tier
  
        def parse_args
          split_switch = RecursiveRealms.split_command(@cmd)
          self.topcmd = split_switch[0]
          self.type = split_switch[1]
          self.value = split_switch[2]
        end
  
        def handle
          client.emit_ooc "#{topcmd}, #{type}, #{value}"

          if self.value.nil?
            return RecursiveRealms.handle_missing_type(client, enactor) 
          end 
          
          # Check if the tier is a valid number
          if !self.value || !self.value.is_integer? || self.value.to_i <= 0
            return client.emit_failure "Please provide a valid tier number."
          end   
          
          # Find or create the traits record
          traits = enactor.rr_traits.first
          if traits.nil?
            return client.emit_failure "You need to set a character type before you can adjust the tier."
          end

          # Update the tier in the character's traits
          traits.update(tier: self.tier.to_i)
          client.emit_success "Your character's tier has been updated to #{self.tier}."

          # Now adjust the effort based on the new tier
          chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }

          if chartype
            # Fetch the correct effort value for the new tier from the YAML
            tier_key = "Tier #{self.tier}"
            effort = chartype['Tiers'][tier_key]['Effort']

            if effort
              traits.update(effort: effort)
              client.emit_success "Effort for #{traits.type.capitalize} (Tier #{self.tier}) has been set to #{effort}."
            else
              client.emit_failure "Effort information for #{traits.type.capitalize} (Tier #{self.tier}) not found in configuration."
            end
          else
            client.emit_failure "Character type '#{traits.type}' not found in the configuration."
          end           
        end
      end
    end
  end        
