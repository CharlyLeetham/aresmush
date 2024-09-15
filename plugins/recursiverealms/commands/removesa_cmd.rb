module AresMUSH
    module RecursiveRealms
      class RemoveSACmd
        include CommandHandler
  
        attr_accessor :tier
  
        def parse_args
          split_switch = RecursiveRealms.multi_split_command(@cmd)
  
          # Ensure we don't raise errors when not enough arguments are passed
          self.tier = split_switch.length > 2 ? split_switch[2].to_i : nil
        end
  
        def handle
          abilities = enactor.rr_specialabilities
  
          if abilities.empty?
            client.emit_failure "You have no special abilities to remove."
            return
          end
  
          if self.tier.nil?
            # Remove all special abilities if no tier is specified
            abilities.each { |ability| ability.delete }
            client.emit_success "All special abilities have been removed."
          else
            # Remove only the special abilities for the specified tier
            abilities_to_remove = abilities.select { |ability| ability.tier == self.tier }
  
            if abilities_to_remove.empty?
              client.emit_failure "No special abilities found for Tier #{self.tier}."
            else
              abilities_to_remove.each { |ability| ability.delete }
              client.emit_success "All special abilities for Tier #{self.tier} have been removed."
            end
          end
        end
      end
    end
  end
  