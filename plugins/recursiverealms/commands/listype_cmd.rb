module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :topcmd, :mine, :value, :charly   

      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
          self.topcmd = titlecase_arg(args.arg1)
          self.mine = titlecase_arg(args.arg2)
          self.value = titlecase_arg(args.arg3)
          self.charly = "Top loop"
        else
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.topcmd = titlecase_arg(args.arg1)
          self.mine = titlecase_arg(args.arg2)
          self.charly = "Bottom loop"
        end
      end

      def handle
        @client.emit_ooc "topcmd: #{topcmd}, type: #{mine}, value: #{value}, charly: #{charly}"
        #chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @detail }
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
