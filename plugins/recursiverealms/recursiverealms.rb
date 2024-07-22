module AresMUSH
    module RecursiveRealms
      def self.plugin_dir
        File.dirname(__FILE__)
      end
  
      def self.shortcuts
        Global.read_config("RecursiveRealms", "shortcuts")
      end
  
      def self.get_cmd_handler(client, cmd, enactor)

        client.emit_ooc "Debug: Entered get_cmd_handler"
        client.emit_ooc "Debug: cmd.root is '#{cmd.root}'"
        client.emit_ooc "Debug: cmd.switch is '#{cmd.switch}'"
        client.emit_ooc "Debug: cmd.args initial state is '#{cmd.args}'"
        case cmd.root          
        when "rr"
          case cmd.switch               
          when "start"
            return StartCmd
          when "types"
            client.emit_ooc "Debug: cmd.switch is 'types'"
            client.emit_ooc "Debug: cmd.args before check is '#{cmd.args}'"           
            if cmd.args

            # Debugging output for cmd.args
            client.emit_ooc "Debug: Command arguments are '#{cmd.args}'"
            Global.logger.debug "Debug: Command arguments are '#{cmd.args}'"
            return                
              if cmd.args =~ /^(\w+)\/(tiers|sa|moves|full)$/
                type, detail = $1.downcase, $2.downcase
                case detail
                when "tiers"
                  return ListTypeTiersCmd
                when "sa"
                  return ListTypeSACmd
                when "moves"
                  return ListTypeMovesCmd
                when "full"
                  return ListTypeFullCmd
                end
              elsif cmd.args =~ /^(\w+)$/
                self.type = $1.downcase
                return ListTypeCmd
              else
                client.emit_ooc "Error: Invalid command format."
              end
            else
              return ListAllTypesCmd
            end
          when "select"
            return SelectTypeCmd
          when "tier"
            return DisplayTierCmd
          when "attributes"
            return DisplayAttributesCmd
          when "moves"
            return SelectMovesCmd
          end
        end
        nil
      end
  
      def self.get_event_handler(event_name)
        nil
      end
  
      def self.get_web_request_handler(request)
        nil
      end
  
      def self.get_master_help
        return { "RecursiveRealms" => t('recursive_realms.help') }
      end
    end
end