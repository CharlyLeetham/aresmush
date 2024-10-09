module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :tier

      def initialize(chartype, tier = nil)
        @chartype = chartype
        @tier = tier
        super File.dirname(__FILE__) + "/character_type_moves.erb"
      end

      def chartypetitle
        return @chartype["Type"]
      end

      # Get the tiers for the character type, but filter for the requested tier if provided
      def tiers
        if @tier
          # Return only the specific tier
          { "Tier #{@tier}" => @chartype['Tiers']["Tier #{@tier}"] }
        else
          # Return all tiers if no specific tier is requested
          @chartype['Tiers']
        end
      end

      # Check if a move is selected for the character (based on move name and tier)
      def move_selected?(move_name)
        return false unless @enactor && @enactor.rr_traits

        # Check if the move is set in the character's rr_traits
        @enactor.rr_traits.any? do |trait|
          trait.moves && trait.moves.downcase == move_name.downcase && trait.tier == @tier
        end
      end

      # A method to return the traits of the character
      def enactor_traits
        return "No traits found" unless @enactor && @enactor.rr_traits
        @enactor.rr_traits.map(&:inspect).join(", ")
      end
    end
  end
end