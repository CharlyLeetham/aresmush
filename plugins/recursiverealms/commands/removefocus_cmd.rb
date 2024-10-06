module AresMUSH
  module RecursiveRealms
    class RemoveFocusCmd
      include CommandHandler

      def handle
        # Retrieve the character's traits
        traits = enactor.rr_traits.first
        if traits.nil? || traits.focus.nil? || traits.focus.empty?
          client.emit_failure "You do not have a focus to remove."
          return
        end

        # Remove the focus
        old_focus = traits.focus
        traits.update(focus: nil) # Clear the focus from the character's traits

        client.emit_success "Your focus '#{old_focus.capitalize}' has been removed."
      end
    end
  end
end