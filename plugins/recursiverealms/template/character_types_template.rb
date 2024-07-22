module AresMUSH
    module RecursiveRealms
      class CharacterTypeTemplate < ErbTemplateRenderer
        attr_accessor :character
  
        def initialize(character)
          @character = character
          super File.dirname(__FILE__) + "/character_types_template.erb"
        end
      end
    end
  end
  