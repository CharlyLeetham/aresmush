module AresMUSH
  module RecursiveRealms
    class RRSheetTemplate < ErbTemplateRenderer
      attr_accessor :traits, :special_abilities, :moves

      def initialize(traits, special_abilities, moves)
        @traits = traits
        @special_abilities = special_abilities
        @moves = moves
        super File.dirname(__FILE__) + "/rr_sheet.erb"
      end

      def chartypetitle
        return @traits.type.capitalize
      end

      def effort
        return @traits.effort || "N/A"
      end
      
      def might
        return @traits.might || "N/A"
      end      

      def speed
        return @traits.speed || "N/A"
      end

      def effort
        return @traits.effort || "N/A"
      end

      def xp
        return @traits.xp || 0
      end

      def moves_allowed
        return @traits.moves || 0
      end

      def special_abilities_list
        return @special_abilities.map { |ability| ability.name }.join(', ') unless @special_abilities.empty?
        return "None"
      end

      def moves_list
        return @moves.map { |move| move.name }.join(', ') unless @moves.empty?
        return "None"
      end
    end
  end
end