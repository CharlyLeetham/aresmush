module AresMUSH
  module RecursiveRealms
    class CharacterTypeTierTemplate < ErbTemplateRenderer
        attr_accessor :chartype, :tiers
  
        def initialize(chartype, tiers)
          @chartype = chartype
          @tiers = tiers
          super File.dirname(__FILE__) + "/character_type_tier.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end