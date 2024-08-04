module AresMUSH
  module RecursiveRealms
    class ListTypeTiersCmd
      attr_accessor :split_switch, :topcmd, :type, :value

      def parse_args
        split_switch = RecursiveRealms.split_command(@cmd)
        self.topcmd = split_switch[0]
        self.type = split_switch[1]
        self.value = split_switch[2]
      end

      def handle
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
              template = CharacterTypeTierTemplate.new(chartype)
              client.emit template.render
        else
          @client.emit_failure "Character type #{self.type.capitalize} not found. Please check your spelling."
        end
      end
    end
  end
end
