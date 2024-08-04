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
          case cmd.switch               
          when "start"
            return StartCmd
          when ->(args) { args.start_with?('types') }       
                #We're looking to see if there's multiple arguments passed in here.  This needs to be a helper
                client.emit_ooc "Debug: args initial state is '#{args}'"
                split_switch = RecursiveRealms.split_command(args)
                if split_switch.length > 1
                    fr = split_switch[0]
                    detail = split_switch.length > 1 ? split_switch[1] : nil
                    attrib = split_switch.length > 2 ? split_switch[2] : nil
                    client.emit_ooc "Debug: type initial state is '#{split_switch[0]}', '#{fr}'"
                    client.emit_ooc "Debug: detail initial state is '#{split_switch[1]}', '#{detail}'"
                    client.emit_ooc "Debug: attrib initial state is '#{split_switch[2]}', '#{attrib}'"
                end             
                
                if fr && detail && attrib && !attrib.empty?
                    client.emit_ooc "Handling case where all are present: fr = #{fr}, detail = #{detail}, attrib = #{attrib}"
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
                    client.emit_ooc "Handling case where fr and detail are present: fr = #{fr}, detail = #{detail}"
                    detail = detail.downcase
                    return ListTypeCmd
                else
                  client.emit_ooc "Handling default case: fr = #{fr}, detail = #{detail}, attrib = #{attrib}"
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