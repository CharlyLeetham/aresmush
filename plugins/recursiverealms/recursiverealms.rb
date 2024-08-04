#$:.unshift File.dirname(__FILE__)
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
          client.emit_ooc "Debug: cmd.switch initial state is '#{cmd.switch}'"   
          case cmd.switch            
          when "start"
            return StartCmd
          when ->(args) { args.start_with?('types') }       
                #We're looking to see if there's multiple arguments passed in here.  This needs to be a helper
                split_switch = RecursiveRealms.split_command(cmd)
                if split_switch.length > 1
                    fr = split_switch[0]
                    detail = split_switch.length > 1 ? split_switch[1] : nil
                    attrib = split_switch.length > 2 ? split_switch[2] : nil
                end             
                
                if fr && detail && attrib && !attrib.empty?
                    fr = fr.downcase
                    detail = detail.downcase
                    attrib = attrib.downcase
                    case attrib
                    when "tiers"
                        return ListTypeTiersCmd
                    when "sa"
                        return ListTypeSACmd
                    when "moves"
                        return ListTypeMovesCmd
                    when "full"
                        return ListTypeFullCmd
                    end
                elsif fr && detail && (attrib.nil? || attrib.empty?)
                    detail = detail.downcase
                    return ListTypeCmd
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