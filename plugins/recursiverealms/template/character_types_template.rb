module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate < ErbTemplateRenderer
        attr_accessor :char
  
        def initialize(char)
          @char = char
          super File.dirname(__FILE__) + "/character_types.erb"
        end

        def chartypetitle
          return @char["Type"]
        end

      end
    end
  end
  