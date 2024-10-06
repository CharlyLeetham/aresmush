module AresMUSH
  module RecursiveRealms
    class DescriptorListCmd
      include CommandHandler

      def handle
        descriptor_config = Global.read_config("RecursiveRealms", "descriptors")
        
        if descriptor_config.nil?
          client.emit_ooc "Error: Configuration data not found. Please check the rr_descriptor.yml file."
          return
        end

        begin
            template = DescriptorListTemplate.new(descriptor_config)
            client.emit template.render
        rescue => e
          client.emit_ooc "Error: #{e.message}"
          Global.logger.error "Error reading descriptor types: #{e.message}"
        end
      end
    end
  end
end
