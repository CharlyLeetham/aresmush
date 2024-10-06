module AresMUSH
  module RecursiveRealms
    class SetDescriptorCmd
      include CommandHandler

      attr_accessor :descriptor_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.descriptor_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the focus
      end

      def handle
        # If no descriptor name is given, list all available descriptor by calling the helper
        if self.descriptor_name.nil? || self.descriptor_name.empty?
          RecursiveRealms.handle_missing_descriptor(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        # Retrieve character traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end

        # Fetch all focuses from the YAML configuration
        descriptor = Global.read_config("RecursiveRealms", "descriptor")

         # Find the descriptor by name (case-insensitive)
        descriptor = descriptors.find { |f| f['Descriptor'].downcase == self.descriptor_name.downcase }

        if descriptor.nil?
          client.emit_failure "Descriptor '#{self.descriptor_name}' not found."
          RecursiveRealms.handle_missing_descriptor(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        # Check if the character already has a focus
        if traits.descriptor
          client.emit_failure "You already have a Descriptor: #{traits.descriptor.capitalize}. You must clear it first before setting a new descriptor."
          client.emit_ooc "Use rr/remove/descriptor to remove the descriptor."
          display_current_descriptor(enactor, client)
          return
        end

        # Assign the focus to the character
        traits.update(descriptor: descriptor['ID'])
        client.emit_success "Your Descriptor has been set to #{self.descriptor_name.capitalize}."
      end

      def display_current_descriptor(enactor, client)
        traits = enactor.rr_traits.first
        
        if traits.descriptor.nil?
          client.emit_ooc "No Descriptor set."
        else
          # Fetch all descriptors from the YAML configuration
          descriptors = Global.read_config("RecursiveRealms", "descriptor")
          client.emit_ooc "#{descriptors}"
          
          # Find the descriptor by its ID saved in the traits
          #descriptor = descriptors.find { |f| f['ID'] == traits.descriptor }
          
          #if descriptor
          #  client.emit_ooc "Current Descriptor: #{descriptor['Descriptor']}."
          #else
          #  client.emit_ooc "No Descriptor set"
          #end
        end
      end
    end
  end
end