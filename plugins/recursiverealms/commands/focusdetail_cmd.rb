module AresMUSH
  module RecursiveRealms
    class FocusDetailCmd 
      include CommandHandler

      attr_accessor :split_switch, :topcmd, :focus, :value 

      def parse_args
        split_switch = RecursiveRealms.split_command(@cmd)
        self.topcmd = split_switch[0]
        self.focus = split_switch[1]
        self.value = split_switch[2]
      end

      def handle
        client.emit_ooc "#{self.focus}"
        focustype = Global.read_config("RecursiveRealms", "focuses").find { |c| c['Focus'].downcase == self.focus }
        if focustype
              template = FocusDetailTemplate.new(focustype)
              client.emit template.render
        else
          @client.emit_failure "Focus type #{self.focus.capitalize} not found. Please check your spelling."
        end
      end     
    end
  end
end
