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
        super File.dirname(__FILE__) + "/character_types.erb"
        #@client.emit template.result(binding)
      end
    end
  end
end
