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
            when ->(args) { args.start_with?('types') }       
                #We're looking to see if there's multiple arguments passed in here.
                split_switch = cmd.switch.split('/')
                if split_switch.length > 1
                    type = split_switch[0]
                    detail = split_switch.length > 2 ? split_switch[1] : nil
                    client.emit_ooc "Debug: type initial state is '#{split_switch[0]}'"
                    client.emit_ooc "Debug: detail initial state is '#{split_switch[1]}'"
                end             
                
                if type && detail
                    type = type.downcase
                    detail = detail.downcase
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
                else
                    self.type = type.downcase
                    return ListTypeCmd
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