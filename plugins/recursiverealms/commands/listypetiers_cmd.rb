module AresMUSH
  module RecursiveRealms
    class ListTypeTiersCmd
      include CommandHandler
            
      attr_accessor :split_switch, :topcmd, :type, :value, :tiers

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.topcmd = split_switch[0]
        self.type = split_switch[1]
        self.value = split_switch[2]
        self.tiers = split_switch[3]
      end

      def handle
        client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}, tiers: #{tiers}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
          begin
             template = CharacterTypeTierTemplate.new(chartype, tiers)
             client.emit template.render
          rescue => e   
            client.emit_failure "An Error occured: #{e.message}"
            Global.logger.error "Error reading character types: #{e.message}"            
          end
        end
      end
    end
  end
end



