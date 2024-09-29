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
        # If a tier is specified, return only that tier, else return all tiers
        if @tier
          return { @tier => @chartype['Tiers'][@tier] }
        else
          return @chartype['Tiers']
        end
      end
    end
  end
end