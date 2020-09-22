$:.unshift File.dirname(__FILE__)

module AresMUSH
	module Swade
		
		def self.plugin_dir
			File.dirname(__FILE__)
		end
    
		def self.shortcuts
			Global.read_config("swade", "shortcuts")
		end
		

		def self.get_cmd_handler(client, cmd, enactor)
			case cmd.root
				when "swade"
					case cmd.switch
						when "iconicf"
							if (!cmd.args)							 
								return IconicfCmd
							else	
								return IconicfSetCmd
							end
						when "reset"
							return ResetCmd
						when "chargen"
							return ChargenpointsCmd
						# when "race"
							# if (!cmd.args)							 
								# return RaceCmd
							# else
								# return RaceSetCmd
							# end
						# when "hj"
							# if (!cmd.args)							 
								# return HjCmd
							# else
								# return HjSetCmd
							# end
						# when "fandg"
							# if (!cmd.args)							 
								# return FandgCmd
							# else
								# return FandgSetCmd
							# end
						when "stats"
							if (!cmd.args)							 
								return StatsCmd
							else
								# return StatsSetCmd
								return client.emit ("Command Pending")
							end
						when "skill"
							if (!cmd.args)							 
								return SkillCmd
							else
								# return SkillSetCmd
								return client.emit ("Command Pending")
							end
						when "hind"
							if (!cmd.args)							 
								return HindCmd
							else
								# return HindSetCmd
								return client.emit ("Command Pending")
							end
						# when "edge"
							# if (!cmd.args)							 
								# return EdgeCmd
							# else
								# return EdgeSetCmd
							# end
						# when "ppower"
							# if (!cmd.args)							 
								# return PpowerCmd
							# else
								# return PpowerSetCmd
							# end
						# when "mpower"
							# if (!cmd.args)							 
								# return MpowerSetCmd
							# else
								# return MpowerSetCmd
							# end
						# when "cyber"
							# if (!cmd.args)							 
								# return CyberSetCmd
							# else
								#return CyberSetCmd
							# end
						else
							client.emit ("Error")
						end
				when "sheet"
					return SheetCmd
				else
				    client.emit ("hello 33333")
				end
			end
		end

		def self.get_event_handler(event_name)
		  nil
		end

		def self.get_web_request_handler(request)
		  nil
		end

	end
end