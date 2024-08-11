module AresMUSH
  module RecursiveRealms
    class CharacterTypeTierTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          client.emit_ooc chartype
          super File.dirname(__FILE__) + "/character_type_tier.erb"
        end

        def chartypetitle
          return @chartype["Tiers"]
        end

      end
    end
  end