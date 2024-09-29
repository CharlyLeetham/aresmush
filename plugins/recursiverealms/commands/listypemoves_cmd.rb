module AresMUSH
  module RecursiveRealms
    class ListTypeMovesCmd
      include CommandHandler

      attr_accessor :type, :tier

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.type = split_switch[1] # This is the type provided in the command, can be nil if not provided
        self.tier = split_switch.length > 2 ? split_switch[2] : nil # If provided, tier is optional
      end

      def handle
        # If type is missing, use the enactor's traits
        if self.type.nil? || self.type.empty?
          traits = enactor.rr_traits.first
          if traits.nil? || traits.type.nil?
            client.emit_failure "No character type found. Please specify a type or set your character's traits."
            return
          end
          self.type = traits.type.downcase
        end

        # Fetch the character type from the YAML config
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype.nil?
          client.emit_failure "Character type '#{self.type}' not found in the configuration."
          return
        end

        begin
          # If a tier is specified, only show moves for that tier
          if self.tier
            if chartype['Tiers']["Tier #{self.tier}"]
              template = CharacterTypeMovesTemplate.new(chartype, "Tier #{self.tier}")
              client.emit template.render
            else
              client.emit_failure "Tier #{self.tier} not found for character type #{self.type}."
            end
          else
            # If no tier is specified, show all moves for all tiers
            template = CharacterTypeMovesTemplate.new(chartype)
            client.emit template.render
          end
        rescue => e
          client.emit_failure "An error occurred: #{e.message}"
          Global.logger.error "Error reading character types: #{e.message}"
        end
      end
    end
  end
end