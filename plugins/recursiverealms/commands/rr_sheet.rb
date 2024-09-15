module AresMUSH
  module RecursiveRealms
    class RRSheetCmd
      include CommandHandler

      def handle
        # Fetch and display the character's rr_traits
        traits = enactor.rr_traits.first
        if traits
          # Emit the basic trait information
          client.emit_ooc "Character Type: #{traits.type}, Tier: #{traits.tier}, Effort: #{traits.effort}, XP: #{traits.xp}"
      
          # Fetch and display special abilities
          if enactor.rr_specialabilities.empty?
            client.emit_ooc "No special abilities assigned."
          else
            client.emit_ooc "Special Abilities:"
            enactor.rr_specialabilities.each do |ability|
              client.emit_ooc "  - Name: #{ability.name}, Expertise: #{ability.expertise}, SkList: #{ability.sklist}, Tier: #{ability.tier}, Type: #{ability.type}"
            end
          end
        else
          client.emit_ooc "No traits assigned."
        end
      end
      
    end
  end
end