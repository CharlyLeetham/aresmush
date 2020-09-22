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
							case cmd.args
								when ( cmd.args == !nil )
									return IconicfSetCmd
								else
									return IconicfCmd
								end
						when "reset"
							return ResetCmd
						# when "chargen"
							# return ChargenCmd
						# when "race"
							# return RaceCmd
						# when "hj"
							# return HjCmd
						# when "fandg"
							# return FandgCmd
						when "stats"
							return StatsCmd
						when "skill"
							return SkillCmd
						when "hind"
							return HindCmd
						# when "edge"
							# return EdgeCmd
						# when "ppower"
							# return PpowerCmd
						# when "mpower"
							# return MpowerCmd
						# when "cyber"
							# return CyberCmd
						end
				when "sheet"
					return SheetCmd
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