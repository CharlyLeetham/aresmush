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

        template = CharacterTypeTemplate.new(character)
        client.emit template.render        
      end
    end
  end
end
