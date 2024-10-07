module AresMUSH
  module RecursiveRealms
    class ListTypeDescriptorSummCmd
      include CommandHandler

      attr_accessor :type

      def parse_args
        # Use multi_split_command to split and parse the arguments
        args = RecursiveRealms.multi_split_command(@cmd)
        self.type = args[1] # Character type provided in the command (in args[1])

      end

      def handle
        # If type is missing, fall back to using the enactor's traits
        if self.type.nil? || self.type.empty?
          traits = enactor.rr_traits.first
          if traits.nil? || traits.type.nil?
            client.emit_failure "No character type found. Please specify a type or set your character's traits."
            return
          end
          self.type = traits.type.downcase # Use the character's type from traits       
        end

        # Fetch character type from the YAML configuration
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{self.type}' not found in the configuration."
          return
        end

        # Fetch all available focuses from the YAML configuration
        descriptors = Global.read_config("RecursiveRealms", "descriptors")
        # Pass character type and focus data to the template
        template = CharacterTypeDescriptorSummTemplate.new(@enactor, chartype, descriptors)
        client.emit template.render
      end
    end
  end
end