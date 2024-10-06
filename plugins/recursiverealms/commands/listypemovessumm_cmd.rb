module AresMUSH
  module RecursiveRealms
    class ListTypeMovesSummCmd
      include CommandHandler

      attr_accessor :type

      def parse_args
        # Use multi_split_command to split and parse the arguments
        args = RecursiveRealms.multi_split_command(@cmd)
        self.type = args[1] # Character type provided in the command (in args[1])
      end

      def handle
                client.emit_ooc "Here #{self.type}"
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

        # Retrieve the current tier from the character's traits
        traits = enactor.rr_traits.first
        current_tier = traits.tier
        num_moves = traits.moves

        # Show moves for the character's current tier only
        tier_key = "Tier #{current_tier}"
        tier_data = chartype['Tiers'][tier_key]

        if tier_data && tier_data['Moves']
          # Pass only the current tier to the template
          template = CharacterTypeMovesSummTemplate.new(@enactor, chartype, current_tier, num_moves)
          client.emit template.render
        else
          client.emit_failure "Moves not found for Tier #{current_tier} for character type #{self.type.capitalize}."
        end
      end
    end
  end
end