module AresMUSH
  module RecursiveRealms
    class DescriptorDetailCmd 
      include CommandHandler

      attr_accessor :split_switch, :descriptor, :value 

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(cmd) # Using multi_split_command from helpers.rb
        self.value = args[1] # Character type provided in the command (in args[1])
        self.descriptor = args.length > 2 ? args[2] : nil # Optional tier argument is in args[3]
      end

      def handle
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
