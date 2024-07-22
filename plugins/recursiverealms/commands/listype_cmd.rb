module AresMUSH
  module RecursiveRealms
    class ListTypeCmd
      

      def initialize(client, cmd, enactor)
        @client = client
        @cmd = cmd
        @enactor = enactor
        @type = cmd.args.downcase
      end

      def handle
        character = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @type }
        if character
          template = ERB.new(File.read(File.join(AresMUSH.plugin_dir, 'recursiverealms', 'template', 'character_type.erb')))
          @client.emit template.result(binding)
        else
          @client.emit_failure "Character type not found."
        end
      end
    end
  end
end
