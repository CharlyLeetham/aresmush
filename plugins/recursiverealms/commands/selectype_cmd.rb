module AresMUSH
    module RecursiveRealms
      class SelectTypeCmd
        include CommandHandler
  
        attr_accessor :type, :tier
  
        def parse_args
            args = cmd.args.split(" ")
            self.type = args[0].downcase
            self.tier = args[1] ? args[1].to_i : 1 # Default to tier 1 if no tier is specified
          end
  
        def handle
        types = Global.read_config("rr", "rr_types").map { |t| t['Type'].downcase }
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
=begin  
        def display_assigned_attributes
          attributes = enactor.attributes
          special_abilities = enactor.special_abilities
  
          attributes_text = attributes.map { |k, v| "#{k.split('_').map(&:capitalize).join(' ')}: #{v}" }.join(", ")
          special_abilities_text = special_abilities.map { |a| "#{a['Defensive']}, #{a['Practiced With All Weapons']}, #{a['Physical Skills']}, #{a['Translation']}" }.join("\n")
  
          client.emit_ooc "Assigned attributes for Tier 1: #{attributes_text}"
          client.emit_ooc "Special Abilities: #{special_abilities_text}"
        end
=end
      end
    end
  end
  