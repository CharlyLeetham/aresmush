module AresMUSH
    module RecursiveRealms
      def self.plugin_dir
        File.dirname(__FILE__)
      end
  
      def self.shortcuts
        Global.read_config("RecursiveRealms", "shortcuts")
      end
  
      def self.get_cmd_handler(client, cmd, enactor)
        case cmd.root
        when "rr"
          case cmd.switch
          when "start"
            return StartCmd
          when "types"
            if cmd.args
              if cmd.args =~ /^(\w+)\/(tiers|sa|moves|full)$/
                type, detail = $1.downcase, $2.downcase
                case detail
                when "tiers"
                  return ListTypeTiersCmd.new(client, cmd, enactor)
                when "sa"
                  return ListTypeSACmd.new(client, cmd, enactor)
                when "moves"
                  return ListTypeMovesCmd.new(client, cmd, enactor)
                when "full"
                  return ListTypeFullCmd.new(client, cmd, enactor)
                end
              elsif cmd.args =~ /^(\w+)$/
                return ListTypeCmd.new(client, cmd, enactor)
              else
                client.emit_ooc "Error: Invalid command format."
              end
            else
              # Split cmd.switch to handle cases like 'types/vector'
              split_switch = cmd.switch.split('/')
              if split_switch.length > 1
                type = split_switch[1]
                detail = split_switch.length > 2 ? split_switch[2] : nil
  
                case detail
                when "tiers"
                  return ListTypeTiersCmd.new(client, cmd, enactor)
                when "sa"
                  return ListTypeSACmd.new(client, cmd, enactor)
                when "moves"
                  return ListTypeMovesCmd.new(client, cmd, enactor)
                when "full"
                  return ListTypeFullCmd.new(client, cmd, enactor)
                else
                  # Handle case when only type is provided
                  cmd.args = type
                  return ListTypeCmd.new(client, cmd, enactor)
                end
              else
                return ListAllTypesCmd.new(client, cmd, enactor)
              end
            end
  
            if cmd.args
              # Debugging output for cmd.args
              client.emit_ooc "Debug: Command arguments are '#{cmd.args}'"
              
              if cmd.args =~ /^(\w+)\/(tiers|sa|moves|full)$/
                type, detail = $1.downcase, $2.downcase
                case detail
                when "tiers"
                  return ListTypeTiersCmd.new(client, cmd, enactor)
                when "sa"
                  return ListTypeSACmd.new(client, cmd, enactor)
                when "moves"
                  return ListTypeMovesCmd.new(client, cmd, enactor)
                when "full"
                  return ListTypeFullCmd.new(client, cmd, enactor)
                end
              elsif cmd.args =~ /^(\w+)$/
                self.type = $1.downcase
                return ListTypeCmd.new(client, cmd, enactor)
              else
                client.emit_ooc "Error: Invalid command format."
              end
            else
              return ListAllTypesCmd.new(client, cmd, enactor)
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

  