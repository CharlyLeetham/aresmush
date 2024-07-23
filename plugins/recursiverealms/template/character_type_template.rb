module AresMUSH
  module RecursiveRealms
    class CharacterTypeTemplate < ErbTemplateRenderer
        attr_accessor :char
  
        def initialize(char)
          @char = char
          super File.dirname(__FILE__) + "/character_type.erb"
        end

        def chartypetitle
          return @char["Type"]
        end

      end
    end
  end