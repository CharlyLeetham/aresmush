module AresMUSH
  module RecursiveRealms
    class RRSheetTemplate < ErbTemplateRenderer
      attr_accessor :traits

      def initialize(traits)
        @traits = traits
        super File.dirname(__FILE__) + "/rr_sheet.erb"
      end

      def chartypetitle
        return @traits.type.capitalize
      end

      def tier
        return @traits.tier || "N/A"
      end

      def intellect
        return @traits.intellect || "N/A"
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

      def focus
        return @traits.focus || "N/A"
      end

      def descriptor
        return @traits.descriptor || "N/A"
      end

    end
  end
end