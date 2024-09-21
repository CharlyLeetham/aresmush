module AresMUSH
  module RecursiveRealms
    class ListTypeMovesCmd
      include CommandHandler

      attr_accessor :type, :value

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd) # Use multi_split_command
        self.type = split_switch[1] # This is the type provided in the command, can be nil if not provided
        self.value = split_switch[2]
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
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
          begin
            template = CharacterTypeMovesTemplate.new(chartype)
            client.emit template.render
          rescue => e
            client.emit_failure "An error occurred: #{e.message}"
            Global.logger.error "Error reading character types: #{e.message}"
          end
        else
          client.emit_failure "Character type '#{self.type}' not found in the configuration."
        end
      end
    end
  end
end