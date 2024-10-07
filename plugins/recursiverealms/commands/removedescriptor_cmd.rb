module AresMUSH
  module RecursiveRealms
    class RemoveDescriptorCmd
      include CommandHandler

      def handle
        # Retrieve the character's traits
        traits = enactor.rr_traits.first
        if traits.nil? || traits.descriptor.nil? || traits.descriptor.empty?
          client.emit_failure "You do not have a focus to remove."
          return
        end

        # Remove the descriptor
        old_descriptor = traits.descriptor
        traits.update(descriptor: nil) # Clear the focus from the character's traits

        client.emit_success "Your Descriptor '#{old_descriptor.capitalize}' has been removed."
      end
    end
  end
end