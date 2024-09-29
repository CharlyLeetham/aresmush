module AresMUSH
    module RecursiveRealms
      class ListTypeMovesCmd
        include CommandHandler
  
        attr_accessor :type
  
        def parse_args
          self.attrib = cmd.args.downcase
        end
  
        def handle
          client.emit_ooc "#{self.attrib}"
          characters_config = Global.read_config("RecursiveRealms", "characters")
          character = characters_config.find { |c| c['Type'].downcase == self.attrib }
  
          if character.nil?
            client.emit_ooc "Error: Character type not found. Please check the RecursiveRealms.yml file."
            return
          end
  
          begin
            template = CharacterTypeMovesTemplate.new(character)
            client.emit template.render
          rescue => e
            client.emit_ooc "Error: #{e.message}"
            Global.logger.error "Error reading character type moves: #{e.message}"
          end
        end
      end
    end
  end
  