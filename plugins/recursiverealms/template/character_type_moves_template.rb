module AresMUSH
  module RecursiveRealms
    class CharacterTypeMovesTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          super File.dirname(__FILE__) + "/character_type_moves.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end