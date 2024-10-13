module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :tier, :enactor

      def initialize(chartype, tier = nil, enactor)
        @chartype = chartype
        @tier = tier
        @enactor = enactor
        super File.dirname(__FILE__) + "/character_type_moves.erb"
      end

      def chartypetitle
        return @chartype["Type"]
      end

      # Get the tiers for the character type, but filter for the requested tier if provided
      def tiers
        if @tier
          { "Tier #{@tier}" => @chartype['Tiers']["Tier #{@tier}"] }
        else
          @chartype['Tiers']
        end
      end

      # Check if a move is selected for the character
      def move_selected?(move_name)
        return false unless @enactor && @enactor.rr_moves

        # Check if the move is set in the character's rr_moves
        @enactor.rr_moves.any? { |move| move.name.downcase == move_name.downcase }
      end

      # Return enactor's traits (for debugging)
      def enactor_traits
        return "No traits found" unless @enactor && @enactor.rr_traits
        @enactor.rr_traits.map(&:inspect).join(", ")
      end

      # Return enactor's moves (for debugging)
      def enactor_moves
        return "No moves found" unless @enactor && @enactor.rr_moves
        @enactor.rr_moves.map(&:name).join(", ")
      end      
    end
  end
end