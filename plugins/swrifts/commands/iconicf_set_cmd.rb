module AresMUSH    
	module Swrifts
		class IconicfSetCmd
			include CommandHandler
			      
			attr_accessor :target_name, :iconicf_name, :iconicf_title, :init
			
			def parse_args
				self.target_name = enactor_name #Set the character to be the current character
				self.iconicf_name = trim_arg(cmd.args) #Set 'iconicf_name' to be the inputted Iconic Framework
				self.iconicf_title = "iconicf"
				self.init = init
			end

			def required_args
				[ self.target_name, self.iconicf_name ]
			end
			
			
			#----- Check to see:
			# def check_valid_iconicf
				# if !Swrifts.is_valid_iconicf_name?(self.iconicf_name) #Is the Iconic Framework in the list
					# return t('swrifts.iconicf_invalid_name', :name => self.iconicf_name.capitalize) 
				# else
					# ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
						# if !Swrifts.is_valid_cat?(model,"traits") #Are there any traits set - i.e INIT completed.
							# return t('swrifts.iconicf_invalid_init', :name => "Traits")
						# elsif Swrifts.trait_set?(model,"iconicf") #Is the iconic framework already set
							# return t('swrifts.trait_already_set',:name => "Iconic Framework")
						# end
					# end
				# end
				# return nil
			# end
			
#----- Begin of def handle -----			
			def handle  
			
				iconicf = Swrifts.get_iconicf(self.enactor, self.iconicf_name) 
				init = Global.read_config('swrifts', 'init')
				
				#----- This sets the default traits field on the collection -----				
				if (init['traits']) 
				traits = init['traits']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					traits.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						setthing = key.downcase
						# alias the 'rating' for the same reason
						setrating = rating
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsTraits.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Base Traits Set!")
				else 
					# If the this field isn't in swrifts_init.yml, skip and emit to enactor
					client.emit_failure ("Init_char Error - Traits")
				end
				

				## ----- Update Iconic Framework
				ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
					trait = Swrifts.find_traits(model, self.iconicf_title)				
					trait.update(rating: self.iconicf_name)
				end
				# client.emit_success ("Iconic Framework Added")

				## ----- Update Traits (Rank)
				if (iconicf['traits'])
					iconicf_traits=iconicf['traits']
					iconicf_traits.each do |key, rating|
						trait_name = "#{key}".downcase
						mod = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							trait = Swrifts.find_traits(model, trait_name)				
							trait.update(rating: mod)
						end
					end
					# client.emit_success ("Rank Updated")
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					# client.emit_failure ("Rank unchanged")
				end
						
				#----- This sets the default stats field on the collection -----				
				if (init['stats']) 
				stats = init['stats'] 
					stats.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsStats.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Stats Set!")
				else 
					client.emit_failure ("Init_char Error - Stats")
				end
						
				#----- This sets the maximum stats field on the collection -----				
				if (init['stat_max']) 
				stat_max = init['stat_max']
					stat_max.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsStatsmax.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Stat Maximums Set!")
				else 
					client.emit_failure ("Init_char Error - Stat_max")
				end
						
				#----- This sets the default minimums on the Character -----				
				if (init['chargen_min'])
				chargen_min = init['chargen_min']
					chargen_min.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsChargenmin.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Chargen Mins Set!")
				else 
					client.emit_failure ("Init_char Error - Chargen_Min")
				end  						
						
				#----- This sets the default Advances on the Character -----				
				if (init['advances'])
				advances = init['advances']					
					advances.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsAdvances.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Advances Set!")
				else 
					client.emit_failure ("Init_char Error - Advances")
				end 				

				## ----- Update Stats
				if (iconicf['stats'])
					iconicf_stats=iconicf['stats']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_stats.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						stat_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the stat
						current_rating = Swrifts.stat_rating(enactor, stat_name)
						# add Iconic Framework bonus to Initial stat
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							stat = Swrifts.find_stat(model, stat_name)				
							stat.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.iconicstats_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					# client.emit_failure ("This Iconic Framework has no Stat changes")
				end
						
				#----- This sets the default derived stats field on the collection -----				
				if (init['dstats']) 
				dstats = init['dstats']
					dstats.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsDstats.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Derived Stats Set!")
				else 
					client.emit_failure ("Init_char Error - DStats")
				end

				#----- This sets the default skills on the Character -----				
				if (init['skills'] )
				skills = init['skills'] 
					skills.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsSkills.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Skills Set!")
				else 
					client.emit_failure ("Init_char Error - Skills")
				end 					

				## ----- Update Skills
				if (iconicf['skills'])
					iconicf_skills=iconicf['skills'] 
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_skills.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						skill_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the skill
						current_rating = Swrifts.skill_rating(enactor, skill_name).to_i
						# add Iconic Framework bonus to Initial skill
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							skill = Swrifts.find_skill(model, skill_name)				
							skill.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.iconicskills_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					# client.emit_failure ("This Iconic Framework has no Skill changes")
				end
				

				#----- This sets the default Chargen Points on the Character -----				
				if (init['chargen_points'] )
				chargen_points = init['chargen_points'] 
					chargen_points.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsChargenpoints.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Chargen Points Set!")
				else 
					client.emit_failure ("Init_char Error - Chargen Points")
				end			
				
				## ----- Update Chargen Points
				if (iconicf['chargen_points'])
					iconicf_chargen_points=iconicf['chargen_points']
					# grab the list from the config file and break it into 'key' (before the ':') and 'rating' (after the ':')
					iconicf_chargen_points.each do |key, rating|
						# alias the 'key' because the command below doesn't parse the #'s and {'s etc.
						point_name = "#{key}".downcase
						# alias the 'rating' for the same reason and set it to an integer
						mod = "#{rating}".to_i
						# get the current rating of the skill
						current_rating = Swrifts.chargen_points_rating(enactor, point_name).to_i
						# add Iconic Framework bonus to Initial skill
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							# update the collection
							points = Swrifts.find_chargen_points(model, point_name)				
							points.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.chargen_points_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					# client.emit_failure ("This Iconic Framework has no Chargen Point changes")
				end

				#----- This sets the default counters field on the collection -----				
				if (init['counters']) 
				counters = init['counters']
					counters.each do |key, rating|
						setthing = "#{key}".downcase
						setrating = "#{rating}"
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsCounters.create(name: setthing, rating: setrating, character: model)
						end
					end
					# client.emit_success ("Counters Set!")
				else 
					client.emit_failure ("Init_char Error - Counters")
				end
				
				## ----- Update Counters
				if (iconicf['counters'])
					iconicf_counters = iconicf['counters']
					iconicf_counters.each do |key, rating|
						counter_name = "#{key}".downcase
						mod = "#{rating}".to_i
						current_rating = Swrifts.counters_rating(enactor, counter_name).to_i
						new_rating = current_rating + mod
												
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							counters = Swrifts.find_counters(model, counter_name)				
							counters.update(rating: new_rating)
						end
					end
					# client.emit_success t('swrifts.counters_set')
				else 
					# If the Iconic Framework does not have this field in iconicf.yml, skip and emit to enactor
					# client.emit_failure ("This Iconic Framework has no Counters changes")
				end

				# ----- This sets the default Hinderances on the Character -----	
				if (iconicf['hinderances']) 
					iconicf_hinderances=iconicf['hinderances'] 
					iconicf_hinderances.each do |key|
						hinderance_name = "#{key}".downcase
						client.emit (hinderance_name)
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							ss = Swrifts.add_feature(model, SwriftsHinderances, "hinderances", hinderance_name)
							# client.emit ("hind: #{ss}")
						end
					end
					# client.emit_success t('swrifts.iconichinderances_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Hinderances")
				end
				
				# ----- This sets the default Edges on the Character -----				
				if (iconicf['edges'])
					iconicf_edges=iconicf['edges'] 
					iconicf_edges.each do |key|
						edge_name = "#{key}".downcase
						client.emit (edge_name)
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							ss = Swrifts.add_feature(model, SwriftsEdges, "edges", edge_name)
							# client.emit ("llll: #{ss}")
						end
					end
					# client.emit_success t('swrifts.iconicedges_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Edges")
				end

				# ----- This sets the default Magic Powers on the Character -----	
				if (iconicf['magic_powers'])
					iconicf_magic_powers=iconicf['magic_powers'] 
					iconicf_magic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsMpowers.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicmpowers_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Magic Powers")
				end 

				# ----- This sets the default Psionic Powers on the Character -----	
				if (iconicf['psionic_powers'])
					iconicf_psionic_powers=iconicf['psionic_powers']
					iconicf_psionic_powers.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsPpowers.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicppowers_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Psionic Powers")
				end

				# ----- This sets the default Cybernetics on the Character -----	
				if (iconicf['cybernetics'])
					iconicf_cybernetics=iconicf['cybernetics']
					iconicf_cybernetics.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsCybernetics.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconiccybernetics_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Cybernetics")
				end
				
				# ----- This sets the default Abilities on the Character -----	
				if (iconicf['abilities'])
					iconicf_abilities=iconicf['abilities'] 
					iconicf_abilities.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsAbilities.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconicabilities_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Abilities")
				end
				
				# ----- This sets the default Complications on the Character -----
				if (iconicf['complications'])
					iconicf_complications=iconicf['complications'] 
					iconicf_complications.each do |key|
						setthing = "#{key}".downcase
						ClassTargetFinder.with_a_character(self.target_name, client, enactor) do |model|
							SwriftsComplications.create(name: setthing, character: model)
						end
					end
					# client.emit_success t('swrifts.iconiccomplications_set')
				else 
					# client.emit_failure ("This Iconic Framework has no Complications")
				end
				
				client.emit_success t('swrifts.iconicf_complete')
			end
#----- End of def handle -----	

		end
    end
end