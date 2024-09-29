module AresMUSH
  module RecursiveRealms
    class ListTypeMovesCmd
      include CommandHandler

      attr_accessor :type, :tier

      def parse_args
        # Use multi_split_command to split and parse the arguments
        args = RecursiveRealms.multi_split_command(@cmd)
        self.type = args[1] # Character type provided in the command
        self.tier = args.length > 1 ? args[2] : nil # Optional tier argument
        client.emit_ooc "#{type}, #{tier}"
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

        # If a specific tier is provided, show moves only for that tier
        if self.tier
          tier_key = "Tier #{self.tier}"
          tier_data = chartype['Tiers'][tier_key]

          if tier_data && tier_data['Moves']
            # Render only the moves for the specific tier
            template = CharacterTypeMovesTemplate.new(chartype, tier_data)
            client.emit template.render
          else
            client.emit_failure "Moves not found for Tier #{self.tier} for character type #{self.type.capitalize}."
          end
        else
          # Show moves for all tiers
          template = CharacterTypeMovesTemplate.new(chartype, nil) # Pass nil to render all tiers
          client.emit template.render
        end
      end
    end
  end
end