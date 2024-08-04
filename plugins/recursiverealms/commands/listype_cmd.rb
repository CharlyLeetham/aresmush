module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :split_switch, :topcmd, :type, :value 

      def parse_args
        #topcmd, type, value = RecursiveRealms.split_command(@cmd)   
         @client.emit_ooc "topcmd: #{@cmd.inspect}"
        split_switch = RecursiveRealms.split_command(@cmd)
        @client.emit_ooc "split_switch: #{split_switch}"
        topcmd = split_switch[0]
        type = split_switch[1]
        value = split_switch[2]
        @client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}"
      end

      def handle
        @client.emit_ooc "topcmd: #{self.topcmd}, type: #{self.type}, value: #{self.value}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
              template = CharacterTypeTemplate.new(chartype)
              client.emit template.render
        else
          @client.emit_failure "Character type #{self.type} not found. Please check your spelling."
        end
      end     
    end
  end
end
