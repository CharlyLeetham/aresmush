module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
  
        def initialize(characters)
          @characters = characters
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  