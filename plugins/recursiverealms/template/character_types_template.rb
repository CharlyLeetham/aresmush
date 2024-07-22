module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
        attr_accessor :character_types

        def initialize(characters_types)
          self.character_types = characters_types
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  