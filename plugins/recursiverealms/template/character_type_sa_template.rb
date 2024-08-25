module AresMUSH
  module RecursiveRealms
    class CharacterTypeSATemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          super File.dirname(__FILE__) + "/character_type_sa.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end