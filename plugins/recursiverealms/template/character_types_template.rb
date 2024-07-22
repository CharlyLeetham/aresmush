module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
        attr_accessor :characters

        def initialize(characters)
          self.characters = characters
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  