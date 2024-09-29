module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :tier_data, :tier

      def initialize(chartype, tier_data = nil, tier = nil)
        @chartype = chartype
        @tier_data = tier_data
        @tier = tier
        super File.dirname(__FILE__) + "/character_type_moves.erb"
      end

      def chartypetitle
        return @chartype["Type"]
      end

      def render_tiers
        if @tier_data
          # Render only the specific tier
          render_single_tier(@tier, @tier_data)
        else
          # Render all tiers
          @chartype['Tiers'].each do |tier, attrib|
            render_single_tier(tier, attrib)
          end
        end
      end

      def render_single_tier(tier, attrib)
        result = []
        result << "%xh#{tier}:%xn"
        attrib.each do |attribute_name, attribute_value|
          if attribute_name == 'Moves'
            result << "%xh#{attribute_name}:%xn"
            attribute_value.each do |move|
              result << "#{move['Name']} - #{move['Type']} (#{move['Modifier']}, Cost: #{move['Cost']}, Duration: #{move['Duration']})"
            end
          end
        end
        result.join("\n")
      end
    end
  end
end