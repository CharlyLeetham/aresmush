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
          when nil
            return RRCmd           
          when "start"
            return StartCmd
          when ->(args) { args.start_with?('types') }       
                split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb                       
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
                        return ListTypeCmd
                    end
                elsif fr && detail && (attrib.nil? || attrib.empty?)
                    detail = detail.downcase
                    return ListTypeCmd
                else
                    return ListAllTypesCmd
                end 
                
              when ->(args) { args.start_with?('focus') }
              client.emit_ooc "#{cmd}"
              #split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb   
             split_switch = cmd.switch.split('/', 2) # Split into at most 2 parts
  
             arg1 = split_switch[0]
             if split_switch.length > 1
               remaining_parts = split_switch[1].split('/', 2) # Further split the second part, but only once
               arg2 = remaining_parts[0]
               arg3 = remaining_parts.length > 1 ? remaining_parts[1] : nil
             else
               arg2 = nil
               arg3 = nil
             end             
             client.emit "split_switch: #{split_switch.inspect}, arg0: #{arg1}, arg1: #{arg2}, arg2: #{arg3}"  
              #client.emit_ooc "#{split_switch}"                    
              if split_switch.length > 1
                  fr = split_switch[0]
                  detail = split_switch.length > 1 ? split_switch[1] : nil
                  attrib = split_switch.length > 2 ? split_switch[2] : nil
              end 
              
              if fr && detail && attrib && !attrib.empty?
                fr = fr.downcase
                detail = detail.downcase
                attrib = attrib.downcase
                #return ListTypeCmd
                client.emit_ooc "Focus Case 1"
                client.emit_ooc "#{fr}, #{detail}, #{attrib}"
              elsif fr && detail && (attrib.nil? || attrib.empty?)
                detail = detail.downcase
                client.emit_ooc "Focus Case 2"
                client.emit_ooc "#{fr}, #{detail}, #{attrib}"

                #return ListTypeCmd
              else
                client.emit_ooc "Focus Case 3"
                client.emit_ooc "#{fr}, #{detail}, #{attrib}"

                #return ListAllTypesCmd
             end                   
          #I don't know if these are needed, but I'm leaving them as place holders (25 Aug 2024)
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