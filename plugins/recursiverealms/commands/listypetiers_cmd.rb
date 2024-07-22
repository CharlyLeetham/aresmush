module AresMUSH
    module RecursiveRealms
      class ListTypeTiersCmd
        include CommandHandler
  
        attr_accessor :type
  
        def parse_args
          self.type = cmd.args.downcase
        end
  
        def handle
          characters_config = Global.read_config("RecursiveRealms", "characters")
          character = characters_config.find { |c| c['Type'].downcase == self.type }
  
          if character.nil?
            client.emit_ooc "Error: Character type not found. Please check the RecursiveRealms.yml file."
            return
          end
  
          begin
            template = CharacterTypeTiersTemplate.new(character)
            client.emit template.render
          rescue => e
            client.emit_ooc "Error: #{e.message}"
            Global.logger.error "Error reading character type tiers: #{e.message}"
          end
        end
      end
    end
  end
  