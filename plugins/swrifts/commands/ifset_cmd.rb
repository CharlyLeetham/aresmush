module AresMUSH
	module Swrifts
		class IfSetCmd
			include CommandHandler
			  
			attr_accessor :target_name, :iconicf_title

			def parse_args
				self.target_name = enactor_name
				self.iconicf_title = "iconicf"
			end

			
			## ----- start of def handle
			def handle
				chartraits = @char.swrifts_traits
				client.emit ( "#{chartraits}" )
				
				current_rating = Swrifts.trait_rating(enactor, self.iconicf_title)
				client.emit ( "#{current_rating}" )

			end
			## ----- end of def handle
			
		end
	end
end
