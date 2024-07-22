module AresMUSH
  module RecursiveRealms
    class ListAllTypesCmd
      include CommandHandler

      def handle
        characters_config = Global.read_config("RecursiveRealms", "characters")
        
        if characters_config.nil?
          client.emit_ooc "Error: Configuration data not found. Please check the RecursiveRealms.yml file."
          return
        end

        begin
          characters_config.each do |character|
            template = CharacterTypesTemplate.new(character)
            client.emit template.render
          end
        rescue => e
          client.emit_ooc "Error: #{e.message}"
          Global.logger.error "Error reading character types: #{e.message}"
        end
      end
    end
  end
end
