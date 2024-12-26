module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesSummTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :traits, :tier, :num_moves

      def initialize(enactor, chartype, traits, tier = nil)
        @chartype = chartype
        @tier = tier
        @enactor = enactor
        @traits = traits
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

      def total_moves
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @traits.type }      
        RecursiveRealms.calculate_total_moves(chartype, @traits.tier.to_i)
      end

      def tier_moves
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @traits.type }      
        RecursiveRealms.calculate_moves_per_tier(chartype, @traits.tier.to_i)
      end 
      
      def char_moves
        charmoves = @enactor.rr_moves
        return charmoves.map { |move| move.name }.join(', ') unless charmoves.empty?
        return "None"
      end

    end
  end
end