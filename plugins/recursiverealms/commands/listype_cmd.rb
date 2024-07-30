module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :topcmd, :type, :value   

      def parse_args
        if (cmd.args =~ /\//)
          split_switch = cmd.switch.split('/').reject(&:empty?)
          if split_switch.length > 1
            self.topcmd = split_switch[0]
            self.type = split_switch.length > 1 ? split_switch[1].downcase : nil
            self.value = split_switch.length > 2 ? split_switch[2].downcase : nil
        end           

        end
      end

      def handle
        @client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
              template = CharacterTypeTemplate.new(chartype)
              client.emit template.render
        else
          @client.emit_failure "Character type #{type}.capitalize not found. Please check your spelling and try again."
        #end
      end     
    end
  end
end
