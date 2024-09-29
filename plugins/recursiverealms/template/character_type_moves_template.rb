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
    end
  end
end