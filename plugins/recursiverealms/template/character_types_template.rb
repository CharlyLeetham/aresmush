module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
  
        def initialize(characters_config)
          @characters = characters_config
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  