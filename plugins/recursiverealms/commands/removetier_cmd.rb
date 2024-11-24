module AresMUSH
    module RecursiveRealms
      class RemoveTierCmd
        include CommandHandler
  
        attr_accessor :tier, :target_name
  
        def check_permission
          return t('dispatcher.not_allowed') if !RecursiveRealms.can_manage_apps?(enactor)
          return nil
        end
  
        def parse_args
          split_switch = RecursiveRealms.multi_split_command(cmd)
          self.tier = split_switch[2] # The tier value
          self.target_name = split_switch.length > 3 ? split_switch[3] : enactor_name # Optional character name
        end
  
        def handle
        
          client.emit_ooc "Tier: #{self.tier}, Targ: #{self.target_name}"
          # Validate tier input
          if !self.tier.is_integer? || self.tier.to_i <= 0
            client.emit_failure "Please provide a valid tier number."
            return
          end
  
          # Find the target character (default to enactor if no name is provided)
          result = ClassTargetFinder.find(self.target_name, Character, enactor)
  
          if result.error
            client.emit_failure "Error: #{result.error}"
            return
          end
  
          target = result.target
          traits = target.rr_traits.first
  
          if traits.nil?
            client.emit_failure "#{target.name} needs to set a character type before removing a tier."
            return
          end
  
          # Ensure the tier is within the character's current tier range
          current_tier = traits.tier || 0
          if self.tier.to_i > current_tier.to_i
            client.emit_failure "#{target.name} is not set to Tier #{self.tier} or higher."
            return
          end
          # Remove the tier and all tiers above it
          tiers_to_remove = (self.tier.to_i..current_tier.to_i).to_a
          traits.update(tier: self.tier.to_i - 1)
          client.emit_success "#{target.name}'s tier has been updated to #{self.tier.to_i - 1}. Removed Tier(s): #{tiers_to_remove.join(', ')}."
  
          tiers_to_remove.each do |tier|
            # Remove abilities for the tiers being removed
            RecursiveRealms.remove_special_abilities(target, tier, client)
            # Remove moves
            RecursiveRealms.remove_moves(target, tier, client)            
          end
  
          client.emit_success "Special abilities and effects for Tiers #{tiers_to_remove.join(', ')} have been removed for #{target.name}."
        end
      end
    end
  end
  