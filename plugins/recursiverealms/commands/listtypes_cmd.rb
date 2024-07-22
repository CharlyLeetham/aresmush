module AresMUSH
    module RecursiveRealms
      class ListTypesCmd
        include CommandHandler
  
        def handle
          characters_config = Global.read_config("RecursiveRealms", "characters")
          
          if characters_config.nil?
            client.emit_ooc "Error: Configuration data not found. Please check the rr_types.yml file."
            return
          end
  
          begin
            characters_config.each do |character|
              type = character['Type']
              description = character['Descriptor']
              might = character['Might']
              speed = character['Speed']
              intellect = character['Intellect']
              additional_points = character['Additional Points']
              tier1 = character['Tiers']['Tier 1']
              
              effort = tier1['Effort']
              might_edge = tier1['Physical Nature']['Might Edge']
              speed_edge = tier1['Physical Nature']['Speed Edge']
              intellect_edge = tier1['Physical Nature']['Intellect Edge']
              cypher_limit = tier1['Cypher Limit']
              special_abilities = tier1['Special Abilities']
              moves = tier1['Moves']
  
              client.emit_ooc "Type: #{type}"
              client.emit_ooc "Description: #{description}"
              client.emit_ooc "Attributes: Might: #{might}, Speed: #{speed}, Intellect: #{intellect}, Additional Points: #{additional_points}"
              client.emit_ooc "Tier 1:"
              client.emit_ooc "  Effort: #{effort}"
              client.emit_ooc "  Might Edge: #{might_edge}"
              client.emit_ooc "  Speed Edge: #{speed_edge}"
              client.emit_ooc "  Intellect Edge: #{intellect_edge}"
              client.emit_ooc "  Cypher Limit: #{cypher_limit}"
              client.emit_ooc "  Special Abilities:"
              special_abilities.each do |ability|
                client.emit_ooc "    - #{ability['Name']}: #{ability['Description']} (Modifier: #{ability['Modifier']})"
              end
              client.emit_ooc "  Moves:"
              moves.each do |move|
                client.emit_ooc "    - #{move['Name']}: #{move['Description']} (Type: #{move['Type']}, Duration: #{move['Duration']}, Cost: #{move['Cost']}, Modifier: #{move['Modifier']})"
              end
              client.emit_ooc ""
            end
          rescue => e
            client.emit_ooc "Error: #{e.message}"
            Global.logger.error "Error reading character types: #{e.message}"
          end
        end
      end
    end
  end
  