module AresMUSH
	class Character < Ohm::Model
        collection :rr_traits, "AresMUSH::RRTraits"        
		collection :rr_type, "AresMUSH::RRType"
		collection :rr_focus, "AresMUSH::RRFocus"
        collection :rr_might, "AresMUSH::RRMight"
        collection :rr_speed, "AresMUSH::RRSpeed"
        collection :rr_intellect, "AresMUSH::RRIntellect"
        collection :rr_specialabilities, "AresMUSH::RRSpecialAbilities"
        collection :rr_moves, "AresMUSH::RRMoves"        

		attribute :rr_type
		attribute :rr_focus

		before_delete :delete_rr_chargen

		def delete_rr_chargen
			[ self.rr_types, self.rr_focus ].each do |list|
				list.each do |a|
					a.delete
				end
			end
		end
	end

# This will hold the standard information for the character
    class RRTraits < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :tier
        attribute :effort
        attribute :xp 
		reference :character, "AresMUSH::Character"
		index :name
	end

# Can we put the Type in the Traits?
    class RRRype < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :rating
		reference :character, "AresMUSH::Character"
		index :name
	end      

# Can we put the Focus in the Traits?
    class RRFocus < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :tier
		reference :character, "AresMUSH::Character"
		index :name
	end    

    class RRMight < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :pool
        attribute :edge
		reference :character, "AresMUSH::Character"
		index :name
	end  

    class RRSpeed < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :pool
        attribute :edge
		reference :character, "AresMUSH::Character"
		index :name
	end 

    class RRIntellect < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :pool
        attribute :edge
		reference :character, "AresMUSH::Character"
		index :name
	end   

    class RRSpecialAbilities < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :tier
		attribute :type
		attribute :expertise                
        attribute :sklist
		reference :character, "AresMUSH::Character"
		index :name
	end    

    class RRMoves < Ohm::Model
		include ObjectModel
		attribute :name
		attribute :tier
		attribute :type
		attribute :modifier                
        attribute :cost
        attribute :duration
		reference :character, "AresMUSH::Character"
		index :name
	end    
end


