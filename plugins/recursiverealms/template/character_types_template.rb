module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
        attr_accessor :characters

        def initialize(characters)
              # Emit the configuration to the client
  client.emit "Characters Configuration: #{characters.inspect}"
          self.characters = characters
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  