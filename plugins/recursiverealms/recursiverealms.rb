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
              split_switch = RecursiveRealms.multi_split_command(cmd) # In helpers.rb                       
      
              # Ensure we capture 'types', 'vector', 'moves', '1' as individual parts
              fr = split_switch[0] # 'types'
              detail = split_switch.length > 1 ? split_switch[1] : nil # 'vector'
              attrib = split_switch.length > 2 ? split_switch[2] : nil # 'moves'
              tier = split_switch.length > 3 ? split_switch[3] : nil # '1'          
                
                #Types Commands
                if fr && detail && attrib.to_s.strip != "" #if you pass three arguments to rr
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
              
              #Focus Commands  
              when ->(args) { args.start_with?('focus') }
                split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb   
                if split_switch.length > 1
                    fr = split_switch[0]
                    detail = split_switch.length > 1 ? split_switch[1] : nil
                    attrib = split_switch.length > 2 ? split_switch[2] : nil
                end 

                if fr && detail && attrib && !attrib.empty?  #if you pass three arguments to rr
                  fr = fr.downcase
                  detail = detail.downcase
                  attrib = attrib.downcase
                elsif fr && detail && (attrib.nil? || attrib.empty?)  #if you pass two arguments to rr ie. rr/focus/abides in stone
                  detail = detail.downcase
                  return FocusDetailCmd
                else #only one argument passed. ie rr/focus
                  return FocusListCmd
                end

            #Set Commands (for CGen) 
            when ->(args) { args.start_with?('set') }       
              split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb                       
              if split_switch.length > 1
                  fr = split_switch[0]
                  detail = split_switch.length > 1 ? split_switch[1] : nil
                  attrib = split_switch.length > 2 ? split_switch[2] : nil
              end  
              #client.emit_ooc "#{fr}, #{detail}, #{attrib}"                      

              if fr && detail #if you pass at least two arguments to rr ie. rr/set/type/vector
                fr = fr.downcase
                detail = detail.downcase
                case detail
                when "type"
                  return SetTypeCmd
                when "tier"
                  return SetTierCmd
                when "sa"
                  return SetSACmd
                when "moves"
                  return SetMovesCmd
                when "focus"
                  return SetFocusCmd
                end 
              else
                return RRCmd
              end

          #Remove Command (for CGen)    
          when ->(args) { args.start_with?('remove') }       
            split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb                       
            if split_switch.length > 1
                fr = split_switch[0]
                detail = split_switch.length > 1 ? split_switch[1] : nil
                attrib = split_switch.length > 2 ? split_switch[2] : nil
            end                        

            if fr && detail #if you pass at least two arguments to rr ie. rr/set/type/vector
              fr = fr.downcase
              detail = detail.downcase
              case detail
              when "type"
                return SetTypeCmd
              when "tier"
                return SetTierCmd
              when "sa"
                return RemoveSACmd
              when "moves"
                return RemoveMovesCmd    
              when "focus"
                return RemoveFocusCmd                              
              end 
            else
              #client.emit_ooc "Testing"
              return RRCmd
            end            
  
          #reset command
          when "reset"
            return RRResetCmd
          #Sheet command  
          when "sheet"
            return RRSheetCmd
  
          #I don't know if these are needed, but I'm leaving them as place holders (25 Aug 2024)
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