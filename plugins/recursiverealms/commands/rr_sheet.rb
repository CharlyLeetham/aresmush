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
        else
          client.emit_ooc "No traits assigned."
        end
      end
    end
  end
end