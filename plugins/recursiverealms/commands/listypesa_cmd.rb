module AresMUSH
  module RecursiveRealms
    class ListTypeSACmd
      include CommandHandler
            
      attr_accessor :split_switch, :topcmd, :type, :value

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd) #In helpers.rb
        self.topcmd = split_switch[0]
        self.type = split_switch[1]
        self.value = split_switch[2]
      end

      def handle
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == self.type }
        if chartype
          begin
              template = CharacterTypeSATemplate.new(chartype)
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