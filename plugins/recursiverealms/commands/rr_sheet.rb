module AresMUSH
  module RecursiveRealms
    class RRSheetCmd
      include CommandHandler

      def handle
        # Fetch and display the character's rr_traits
        traits = enactor.rr_traits.first
        if traits
          # Emit the basic trait information
          client.emit_ooc "Character Type: #{traits.type}, Tier: #{traits.tier}, Effort: #{traits.effort}, XP: #{traits.xp}, Moves Allowed: #{traits.moves}"
      
          # Fetch and display special abilities
          if enactor.rr_specialabilities.empty?
            client.emit_ooc "No special abilities assigned."
          else
            client.emit_ooc "Special Abilities:"
            enactor.rr_specialabilities.each do |ability|
              client.emit_ooc "  - Name: #{ability.name}, Expertise: #{ability.expertise}, SkList: #{ability.sklist}, Tier: #{ability.tier}, Type: #{ability.type}"
            end
          end

          # Fetch and display moves
          if enactor.rr_moves.empty?
            client.emit_ooc "No moves assigned."
          else
            client.emit_ooc "Moves:"
            enactor.rr_moves.each do |move|
              client.emit_ooc "  - Name: #{move.name}, Type: #{move.type}, Modifier: #{move.modifier}, Cost: #{move.cost}, Duration: #{move.duration}, Tier: #{move.tier}"
            end
          end

          # Fetch the full character configuration from the YAML file based on the character's type
          chartype_config = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }

          if chartype_config
            # Pass the full character configuration to the template
            template = RRSheetTemplate.new(chartype_config)
            client.emit template.render
          else
            client.emit_ooc "Character type configuration not found in the YAML file."
          end
        else
          client.emit_ooc "No traits assigned. Please type rr/set/type/[type] to begin your character creation."
          return RecursiveRealms.handle_missing_type(client, enactor)
        end
      end
    end
  end
end