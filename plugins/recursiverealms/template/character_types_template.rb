module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate
        include TemplateHelpers
        attr_accessor :characters_config :characters

        def initialize(characters_config)
              # Emit the configuration to the client
  client.emit "Characters Configuration: #{characters_config.inspect}"
          self.characters = characters_config
           super File.dirname(__FILE__) + "/character_types.erb"
        end

        private
  
        attr_reader :characters
      end
    end
  end
  