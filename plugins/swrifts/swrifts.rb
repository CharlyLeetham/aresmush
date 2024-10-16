$:.unshift File.dirname(__FILE__)

module AresMUSH
	module Swrifts

		def self.plugin_dir
			File.dirname(__FILE__)
		end

		def self.shortcuts
			Global.read_config("swrifts", "shortcuts")
		end


		def self.get_cmd_handler(client, cmd, enactor)
			# root/args
			case cmd.root
			when "swrifts"
				case cmd.switch
				when "ifset"
					return IfSetCmd
				when "iconicf"
					if (!cmd.args)
						return IconicfCmd
					else
						return IconicfSetCmd
					end
				when "reset"
					return ResetCmd
				when "race"
					if (!cmd.args)
						return RaceCmd
					else
						return RaceSetCmd
					end
				when "hj"
					if (!cmd.args)
						return HjCmd
					else
						return HJSetCmd
					end
				when "fandg"
					if (!cmd.args)
						# return FandgCmd
						return PendingCmd
					else
						# return FandgSetCmd
						return PendingCmd
					end
				when "stats"
					if (!cmd.args)
						return StatsCmd
					else
						return StatsSetCmd
					end
				when "skills"
					if (!cmd.args)
						return SkillCmd
					else
						return SkillsSetCmd
					end
				when "hind"
					if (!cmd.args)
						return HindCmd
					else
						return HinderanceSetCmd
					end
				when "edge"
					if (!cmd.args)
						# return EdgeCmd
						return PendingCmd
					else
						# return EdgeSetCmd
						return PendingCmd
					end
				when "ppower"
					if (!cmd.args)
						# return PpowerCmd
						return PendingCmd
					else
						# return PpowerSetCmd
						return PendingCmd
					end
				when "mpower"
					if (!cmd.args)
						# return MpowerSetCmd
						return PendingCmd
					else
						# return MpowerSetCmd
						return PendingCmd
					end
				when "cyber"
					if (!cmd.args)
						# return CyberSetCmd
						return PendingCmd
					else
						#return CyberSetCmd
						return PendingCmd
					end
				else
					client.emit_failure ("Error - command not recognized")
					return
				end
			when "sheet"
				if (!cmd.switch)
					return SheetCmd
				else
					case cmd.switch
					when "stats"
						return SheetCmd
					when "abils"
						return Sheet2Cmd
					when "chargen"
						return ChargenpointsCmd
					else
						client.emit_failure ("Please use 'sheet/stats', 'sheet/abils', or 'sheet/chargen'.")
					end
				end
			end
		end

		def self.get_event_handler(event_name)
			nil
		end

# Somehow the webrequests come in here. Check the ./public folder for handlers etc
    def self.get_web_request_handler(request)
      case request.cmd
			when "swabilities"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb				
      when "abilities"
        return AbilitiesRequestHandler
      when "edges"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
	  	when "hinderances"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
	  	when "iconicf"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
	  	when "race"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
	  	when "skills"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
	  	when "powers"
        return AttributeListRequestHandler	#See web/attribute_list_request_handler.rb
      end
      nil
    end

	end
end
