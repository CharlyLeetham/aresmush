module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :topcmd, :type, :value, :charly   

      def parse_args
          split_switch = cmd.switch.split('/').reject(&:empty?)
          if split_switch.length > 1
            self.topcmd = split_switch[0]
            self.type = split_switch.length > 1 ? split_switch[1].downcase : nil
            self.value = split_switch.length > 2 ? split_switch[2].downcase : nil
            self.charly = "Bottom loop"
          end           
      end

      def handle
        @client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}, charly: #{charly}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        @client.emit_ooc chartype.inspect
        #if chartype
        #      template = CharacterTypeTemplate.new(chartype)
        #      client.emit template.render
        #else
        #  @client.emit_failure "Character type not found."
        #end
      end     
    end
  end
end
