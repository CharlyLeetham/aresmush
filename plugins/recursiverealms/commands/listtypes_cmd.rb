module AresMUSH
    module Rr
      class ListTypesCmd
        include CommandHandler
  
        def handle
          characters_config = Global.read_config("RecursiveRealms", "characters")
          
          if characters_config.nil?
            client.emit_ooc "Error: Configuration data not found. Please check the RecursiveRealms.yml file."
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
  
              special_abilities_text = special_abilities.map do |ability|
                "    - #{ability['Name']}: #{ability['Description']} (Modifier: #{ability['Modifier']})"
              end.join("\n")
  
              moves_text = moves.map do |move|
                "    - #{move['Name']}: #{move['Description']} (Type: #{move['Type']}, Duration: #{move['Duration']}, Cost: #{move['Cost']}, Modifier: #{move['Modifier']})"
              end.join("\n")
  
              client.emit_ooc <<~OUTPUT
                Type: #{type}
                Description: #{description}
                Attributes:
                  Might: #{might}
                  Speed: #{speed}
                  Intellect: #{intellect}
                  Additional Points: #{additional_points}
                Tier 1:
                  Effort: #{effort}
                  Might Edge: #{might_edge}
                  Speed Edge: #{speed_edge}
                  Intellect Edge: #{intellect_edge}
                  Cypher Limit: #{cypher_limit}
                  Special Abilities:
                #{special_abilities_text}
                  Moves:
                #{moves_text}
                
              OUTPUT
            end
          rescue => e
            client.emit_ooc "Error: #{e.message}"
            Global.logger.error "Error reading character types: #{e.message}"
          end
        end
      end
    end
  end
  