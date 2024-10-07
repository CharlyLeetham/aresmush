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

        # Fetch all descriptors from the YAML configuration
        descriptors = Global.read_config("RecursiveRealms", "descriptors")

        # Remove the descriptor
        old_descriptor = descriptors.find { |d| d['ID'].to_s == traits.descriptor.to_s }
        traits.update(descriptor: nil) # Clear the focus from the character's traits

        client.emit_success "Your Descriptor '#{old_descriptor['Descriptor'].capitalize}' has been removed."
      end
    end
  end
end