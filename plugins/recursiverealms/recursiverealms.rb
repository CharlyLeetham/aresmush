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
              split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb   
              if split_switch.length > 1
                  fr = split_switch[0]
                  detail = split_switch.length > 1 ? split_switch[1] : nil
                  attrib = split_switch.length > 2 ? split_switch[2] : nil
              end 
                  #need a command here
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
          when ->(args) { args.start_with?('set') }       
          split_switch = RecursiveRealms.split_command(cmd) #In helpers.rb                       
            return SetTypeCmd
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