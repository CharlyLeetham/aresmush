module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate < ErbTemplateRenderer
        attr_accessor :character
  
        def initialize(character)
          @character = character
          super File.dirname(__FILE__) + "/character_types.erb"
        end
      end
    end
  end
  