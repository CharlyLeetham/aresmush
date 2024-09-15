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

            # Retrieve and add the special abilities for the type and tier
            special_abilities = chartype['Tiers'][tier_key]['Special Abilities']
            if special_abilities
              RecursiveRealms.add_special_abilities(special_abilities, traits.tier, enactor)
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
=begin
          if types.include?(self.type)
            enactor.update(character_type: self.type)
            enactor.update(tier: self.tier)
            assign_tier_attributes
            client.emit_ooc "You have selected #{self.type.capitalize}."
            client.emit_ooc "Your character is now at Tier #{self.tier}."
            display_assigned_attributes
            client.emit_ooc "Type 'rr/moves' to select your character's moves."
        else
            client.emit_ooc "Invalid character type. Available types: #{types.join(", ")}"
        end
        end
  
        def assign_tier_attributes
            type_data = Global.read_config("rr", "character_types").find { |t| t['Type'].downcase == self.type }
            tier_data = type_data['Tiers']["Tier #{self.tier}"]
            attributes = {
              might: type_data['Might'],
              speed: type_data['Speed'],
              intellect: type_data['Intellect'],
              additional_points: type_data['Additional Points'],
              effort: tier_data['Effort'],
              might_edge: tier_data['Might Edge'],
              speed_edge: tier_data['Speed Edge'],
              intellect_edge: tier_data['Intellect Edge'],
              cypher_use: tier_data['Cypher Use']
            }
            enactor.update(attributes: attributes)
            enactor.update(special_abilities: tier_data['Special Abilities'])
        end
 
        def display_assigned_attributes
          attributes = enactor.attributes
          special_abilities = enactor.special_abilities
  
          attributes_text = attributes.map { |k, v| "#{k.split('_').map(&:capitalize).join(' ')}: #{v}" }.join(", ")
          special_abilities_text = special_abilities.map { |a| "#{a['Defensive']}, #{a['Practiced With All Weapons']}, #{a['Physical Skills']}, #{a['Translation']}" }.join("\n")
  
          client.emit_ooc "Assigned attributes for Tier 1: #{attributes_text}"
          client.emit_ooc "Special Abilities: #{special_abilities_text}"
        end
=end 