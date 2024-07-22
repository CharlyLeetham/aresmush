module AresMUSH
  module RecursiveRealms
    class ListTypeTiersCmd
      attr_accessor :fr, :detail

      def initialize(client, cmd, enactor)
        @client = client
        @cmd = cmd
        @enactor = enactor
        split_args = cmd.args.split('/')
        self.fr = split_args[0].downcase
        self.detail = split_args[1].downcase
      end

      def handle
        character = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.fr }
        if character
          @client.emit "Type: #{character['Type']}\nDescription: #{character['Descriptor']}\nTiers:\n#{character['Tiers'].keys.map { |tier| format_tier(tier, character['Tiers'][tier]) }.join("\n")}"
        else
          @client.emit_failure "Character type not found."
        end
      end

      def format_tier(tier, details)
        "#{tier}: #{details['Description']}"
      end
    end
  end
end
