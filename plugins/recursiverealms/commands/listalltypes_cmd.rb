module AresMUSH
  module RecursiveRealms
    class ListAllTypesCmd
      include CommandHandler

      def initialize(client, cmd, enactor)
        @client = client
        @cmd = cmd
        @enactor = enactor
      end

      def handle
        characters_config = Global.read_config("RecursiveRealms", "characters")
        template = CharacterTypesTemplate.new(characters_config)
        client.emit template.render
      end
    end
  end
end
