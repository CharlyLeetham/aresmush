module AresMUSH
    module RecursiveRealms

		def self.plugin_dir
			File.dirname(__FILE__)
		end

		def self.shortcuts
			Global.read_config("rr", "shortcuts")
		end 
        
        def self.get_cmd_handler(client, cmd, enactor)
            case cmd.root
            when "rr"
              case cmd.switch
              when "start"
                return StartCmd
              when "types" #First step is to select the Character Type
                if (!cmd.args)
                    return TypesCmd  #if rr/types is entered, all the Character types will be shown
                else
                    return SelectTypeCmd
                end
            
            #    This next section of code is probably better off used in the sheet command.
              
              when "tier" 
                if (!cmd.args)
                    return DisplayTierCmd #Is meant to display the Tier set on the character
                else
                    return SetTierCmd #Allows for a manual override of the Tier. Has implications to Attributes and Moves. Potentially Admin only function
                end
              when "attributes"
                if (!cmd.args)
                    return DisplayAttributesCmd #Supposed to display the attributes set on the character. This is a SHEET command
                else
                    return AssignAttributesCmd #Allows for attributes to manually set on the Character. Potentially Admin only function
                end

            # This section is definitely part of CGen
              when "moves"
                if (!cmd.args)
                    return DisplayMovesCmd  #Supposed to display the MOVES set on the character.  This is a SHEET command
                else
                    return SelectMovesCmd  #Allows for the moves to manually set.  Must be usuable by the player
                end
              end
            end
            nil
        end

    end
 end
 