module AresMUSH
  module RecursiveRealms
    class DescriptorDetailCmd 
      include CommandHandler

      attr_accessor :split_switch, :descriptor, :value 

      def parse_args
        # Use multi_split_command to split and parse the arguments
        args = RecursiveRealms.multi_split_command(@cmd)
        self.descriptor = args[2] # Character type provided in the command (in args[1])
      end

      def handle
        client.emit_ooc "here #{args.inspect}"
        descriptortype = Global.read_config("RecursiveRealms", "descriptors").find { |c| c['Descriptor'].downcase == self.descriptor.downcase }
        if descriptortype
              template = DescriptorDetailTemplate.new(descriptortype)
              client.emit template.render
        else
          @client.emit_failure "Descriptor type #{self.descriptor.capitalize} not found. Please check your spelling."
        end
      end     
    end
  end
end
