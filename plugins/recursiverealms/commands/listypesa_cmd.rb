module AresMUSH
  module RecursiveRealms
    class ListTypeSACmd
      include CommandHandler
            
      attr_accessor :split_switch, :topcmd, :type, :value, :tiers

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd) #In helpers.rb
        self.topcmd = split_switch[0]
        self.type = split_switch[1]
        self.value = split_switch[2]
        self.tiers = split_switch[3]
      end

      def handle
        client.emit_ooc ("Tiers: #{tiers}")
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
          begin

            if self.tiers.nil? || self.tiers.empty?
              template = CharacterTypeSATemplate.new(chartype, nil) # Pass nil to show all tiers
            else
              # Otherwise, show the specific tier
              template = CharacterTypeSATemplate.new(chartype, self.tiers)
            end            
              client.emit template.render
          rescue => e   
            client.emit_failure "An Error occured: #{e.message}"
            Global.logger.error "Error reading character types: #{e.message}"            
          end
        end
      end
    end
  end
end