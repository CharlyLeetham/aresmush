module AresMUSH
  module RecursiveRealms
    class DescriptorDetailCmd
      include CommandHandler

      attr_accessor :descriptor

      def parse_args
        # Use multi_split_command to split and parse the arguments
        args = RecursiveRealms.multi_split_command(@cmd)
        self.descriptor = args.length > 2 ? args[1] : nil # Descriptor provided in the command (third argument)
      end

      def handle
        if self.descriptor.nil? || self.descriptor.empty?
          client.emit_failure "You must provide a descriptor to view its details."
          return
        end

        client.emit_ooc "Arguments: #{args.inspect}, Descriptor: #{self.descriptor}"

        # Retrieve the descriptor type from the YAML configuration
        descriptortype = Global.read_config("RecursiveRealms", "descriptors").find { |c| c['Descriptor'].downcase == self.descriptor.downcase }

        if descriptortype
          # Render the descriptor detail template
          template = DescriptorDetailTemplate.new(descriptortype)
          client.emit template.render
        else
          client.emit_failure "Descriptor type '#{self.descriptor.capitalize}' not found. Please check your spelling."
        end
      end
    end
  end
end