module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :topcmd, :type, :value 

      def parse_args
        topcmd, type, value = split_command(@cmd)   
      end

      def handle
        @client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
              template = CharacterTypeTemplate.new(chartype)
              client.emit template.render
        else
          @client.emit_failure "Character type #{type.capitalize} not found. Please check your spelling."
        end
      end     
    end
  end
end
