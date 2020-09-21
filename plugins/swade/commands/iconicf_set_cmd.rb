module AresMUSH    
	module Swade
		class IconicfSetCmd
			include CommandHandler
      
			attr_accessor :goals

			def parse_args
				self.goals = trim_arg(cmd.args)
			end

			def handle
				enactor.update(swade_iconicf: self.goals)
			client.emit_success "Goals set!"
			end
		end
	end
end