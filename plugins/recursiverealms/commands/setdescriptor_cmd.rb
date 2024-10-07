module AresMUSH
  module RecursiveRealms
    class SetDescriptorCmd
      include CommandHandler

      attr_accessor :descriptor_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.descriptor_name = split_switch[2] # The name of the descriptor
      end

      def handle
        if descriptor_name.blank?
          RecursiveRealms.handle_missing_descriptor(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end

        descriptors = Global.read_config("RecursiveRealms", "descriptors")
        descriptor = descriptors.find { |d| d['Descriptor'].casecmp(descriptor_name).zero? }

        if descriptor.nil?
          client.emit_failure "Descriptor '#{descriptor_name}' not found."
          RecursiveRealms.handle_missing_descriptor(Global.read_config("RecursiveRealms", "characters"), enactor, client)
          return
        end

        if traits.descriptor
          existing_descriptor = descriptors.find { |d| d['ID'].to_s == traits.descriptor.to_s }
          client.emit_failure "You already have a Descriptor: #{existing_descriptor['Descriptor'].capitalize}. You must clear it first before setting a new descriptor."
          client.emit_ooc "Use rr/remove/descriptor to remove the descriptor."
          return
        end

        traits.update(descriptor: descriptor['ID'])
        client.emit_success "Your Descriptor has been set to #{descriptor_name.capitalize}."
      end

    end
  end
end