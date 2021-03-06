module AresMUSH    
	module Swrifts
		class HJSetCmd
			include CommandHandler
			      
			attr_accessor :target, :hj_name, :hj_set, :hj_table_name
			
			#command example: swrifts/hj 1=Body Armor
			
			def parse_args
			    args = cmd.parse_args(ArgParser.arg1_equals_arg2) #Split the arguments into two around the =
			    self.target = enactor #Set the character to be the current character
			    self.hj_name = "hj" << trim_arg(args.arg1) #set the hj slot 'hj1'
				self.hj_set = "#{hj_name}_options" # 'hj1_options'
			    self.hj_table_name = trim_arg(args.arg2).downcase #set the hj name 'Body Armor'
			end

			def required_args
				[ self.target, self.hj_name, self.hj_table_name ]
			end
			
			
			#----- Check to see:
			def check_valid_hj_table
			
				icf_trait = self.target.swrifts_traits.select { |a| a.name == "iconicf" }.first #get the Iconic Framework trait off of the character
				icf_name = icf_trait.rating #get the Iconic Framework name off the character
				icf_name = icf_name.downcase
								
				icf_yml = Global.read_config('swrifts', 'iconicf') #get all the iconicf yml info
				icf_hash = icf_yml.select { |a| a['name'].downcase == icf_name }.first #get the specific iconicf info
				
				hjarray = icf_hash.select{ |a| a == hj_set }.first #pull the hj1_options array out of the Iconic Framework entry
				
				hjvalue = hjarray[1] #pull the hj1_options value out of the array
				hjvalue_downcase = "#{hjvalue}".downcase
				hj_check = hjvalue_downcase.include?(hj_table_name) #see if the hj table is on the list
				
				if  hj_check == false #Is the HJ on the IcF's list
					return t('swrifts.hj_table_invalid_name', :table => self.hj_table_name.capitalize) 
				else
				end
			end
			
			def check_hj_selected
								
				hj_attr = self.target.swrifts_heroesj.select { |a| a.name == self.hj_name }.first #get the hj1 array out of the heroesj collection off of the character
				if (hj_attr)
					hj_selected = hj_attr.table #get the name out of the array
					if hj_selected != "None"
						return t('swrifts.hj_already_selected')
					else
					end
				else
				end
			end
			
#----- Begin of def handle -----			
			def handle  
			
			model = self.target #character
			# collection = "SwriftsHeroesj"
			element_name = self.hj_name #hj1
			element_table = self.hj_table_name #Body Armor
			
			element_desc = Swrifts.hj_desc(model, element_name, element_table)
			
			hj_element = model.swrifts_heroesj.select { |a| a.name.downcase == element_name }.first			
			hj_element.update(table: element_table)	
			hj_element.update(description: element_desc)
		
			client.emit_success t('swrifts.hjselect_complete', :table => self.hj_table_name.capitalize, :name => self.hj_name.capitalize)
			end
#----- End of def handle -----	

		end
    end
end