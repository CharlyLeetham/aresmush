module AresMUSH
  module RecursiveRealms
    class ListTypeTiersCmd
      include CommandHandler
            
      attr_accessor :split_switch, :topcmd, :type, :value, :tiers

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.topcmd = split_switch[0]
        self.type = split_switch[1]
        self.value = split_switch[2]
        self.tiers = split_switch[3]
      end

      def handle
        client.emit_ooc "topcmd: #{topcmd}, type: #{type}, value: #{value}, tiers: #{tiers}"
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
          begin
            # If no specific tier is provided, show all tiers
            if self.tiers.nil? || self.tiers.empty?
              template = CharacterTypeTierTemplate.new(chartype, nil) # Pass nil to show all tiers
            else
              # Otherwise, show the specific tier
              template = CharacterTypeTierTemplate.new(chartype, self.tiers)
            end
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



