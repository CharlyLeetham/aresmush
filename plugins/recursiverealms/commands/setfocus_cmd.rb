module AresMUSH
  module RecursiveRealms
    class SetFocusCmd
      include CommandHandler

      attr_accessor :focus_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.focus_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the focus
      end

      def handle
        # If no focus name is given, list all available focuses by calling the helper
        if self.focus_name.nil? || self.focus_name.empty?
          RecursiveRealms.handle_missing_focus(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        # Retrieve character traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end

        # Fetch all focuses from the YAML configuration
        focuses = Global.read_config("RecursiveRealms", "focuses")
        focus = focuses.find { |f| f['Focus'].downcase == self.focus_name.downcase }

        if focus.nil?
          client.emit_failure "Focus '#{self.focus_name}' not found."
          RecursiveRealms.handle_missing_focus(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        # Check if the character already has a focus
        if traits.focus
          client.emit_failure "You already have a focus: #{traits.focus.capitalize}. You must clear it first before setting a new focus."
          return
        end

        # Assign the focus to the character
        traits.update(focus: self.focus_name)
        client.emit_success "Your focus has been set to #{self.focus_name.capitalize}."
      end
    end
  end
end