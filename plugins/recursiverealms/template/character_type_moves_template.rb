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

      def tiers
        # If a tier is specified, ensure only the relevant data is returned
        if @tier
          return { "Tier #{@tier}" => @chartype['Tiers']["Tier #{@tier}"] }
        else
          return @chartype['Tiers']
        end
      end

      # Check if a move is selected for the character
      def move_selected?(move_name)
        # Ensure enactor and rr_traits are defined
        return false unless @enactor && @enactor.rr_traits

        # Check if the move is set in the character's rr_traits
        @enactor.rr_traits.any? { |trait| trait.moves.downcase == move_name.downcase }
      end
    end
  end
end