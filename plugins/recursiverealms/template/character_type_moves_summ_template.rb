module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesSummTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :tier, :num_moves

      def initialize(enactor, chartype, tier = nil, num_moves = nil)
        @chartype = chartype
        @tier = tier
        @num_moves = num_moves
        @enactor = enactor
        super File.dirname(__FILE__) + "/character_type_moves_summ.erb"
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

      def current_moves
        @enactor.rr_moves.map(&:name).map(&:downcase)
      end

    end
  end
end