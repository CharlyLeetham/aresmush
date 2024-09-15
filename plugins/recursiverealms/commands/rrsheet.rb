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
        else
          client.emit_ooc "No traits assigned."
        end        
        #template = RRSheetTemplate.new(traits_info)
        #client.emit template.render        
      end
    end
  end
end