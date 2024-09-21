module AresMUSH
    module RecursiveRealms
      class SetTypeCmd
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

          chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.value }
          if chartype
            client.emit_ooc "#{self.value.capitalize} Selected"
            # Find the traits record, or create a new one if it doesn't exist
            traits = enactor.rr_traits.first || RRTraits.create(character: enactor)
            
            # Update the traits with the new type
            traits.update(type: self.value)
            client.emit_success "Your character type has been updated to #{self.value.capitalize}."

            if traits.tier.nil? || traits.tier.empty?
              traits.update(tier: 1)
              client.emit_success "Tier was empty and has been automatically set to 1."
            else
              client.emit_ooc "Tier is already set to #{traits.tier} and will not be changed."
            end 
            
            # Set the Effort value from the YAML based on the type and tier
            tier_key = "Tier #{traits.tier}"
            effort = chartype['Tiers'][tier_key]['Effort']
            if effort
              traits.update(effort: effort)
              client.emit_success "Effort for #{self.type.capitalize} (Tier #{traits.tier}) set to #{effort}."
            else
              client.emit_failure "Effort information for #{self.value.capitalize} (Tier #{traits.tier}) not found."
            end  

            #Add the number of moves allowed to the character record
            moves_allowed_total = 0

            (1..traits.tier.to_i).each do |tier|
              tier_key = "Tier #{tier}"
              moves_allowed_for_tier = chartype['Tiers'][tier_key] ? chartype['Tiers'][tier_key]['Moves Allowed'] : nil
              
              if moves_allowed_for_tier
                moves_allowed_total += moves_allowed_for_tier
              else
                client.emit_ooc "Number of Allowed Moves for #{self.type.capitalize} (Tier #{tier}) not found. Skipping."
              end
            end
            
            traits.update(moves: moves_allowed_total)
            client.emit_success "Total Number of Allowed Moves for #{self.type.capitalize} (up to Tier #{traits.tier}) set to #{moves_allowed_total}."

            # Retrieve and add the special abilities for the type and tier
            special_abilities = chartype['Tiers'][tier_key]['Special Abilities']
            if special_abilities
              RecursiveRealms.add_special_abilities(special_abilities, traits.tier, enactor, client)
            else
              client.emit_ooc "No Special Abilities found for #{self.value.capitalize} (Tier #{traits.tier})."
            end
          else
            RecursiveRealms.handle_invalid_type(client, self.value, enactor) #in cg_helpers.rb
          end 
        end
      end
    end
  end        
