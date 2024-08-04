module AresMUSH
  module RecursiveRealms
    class CharacterTypeTierTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          super File.dirname(__FILE__) + "/character_type_tier.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end