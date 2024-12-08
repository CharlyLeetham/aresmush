module AresMUSH
    module RecursiveRealms


        def self.list_all_special_abilities(abilities, enactor, client, traits)
            if abilities.nil? || abilities.empty?
            client.emit_failure "No special abilities available for #{traits.type.capitalize}."
            return
            end
        
            current_tier = traits.tier
            client.emit_ooc "Available Special Abilities for #{traits.type.capitalize} (Tier #{current_tier}):"
        
            # Retrieve the list of abilities set on the character
            character_abilities = enactor.rr_specialabilities&.map(&:name)&.map(&:downcase) || []
        
            # Split abilities into two groups: those with expertise of 1 and those with 2 or more
            expertise_one_abilities = abilities.select { |ability| ability['Expertise'].to_s.split('/').first.to_i == 1 }
            expertise_two_or_more_abilities = abilities.select { |ability| ability['Expertise'].to_s.split('/').first.to_i > 1 }
        
            # Function to display abilities
            display_abilities = lambda do |ability_list|
            ability_list.each do |ability|
                ability_name = ability['Name']
                next unless ability_name # Skip abilities without a name
        
                ability_name_downcase = ability_name.downcase
                is_set = character_abilities.include?(ability_name_downcase)
                display_name = is_set ? "%xg#{ability_name}%xn" : "%xr#{ability_name}%xn"
        
                tier = ability['Tier'] || 'Unknown'
        
                # Display the ability name, status, and tier
                if ability['SkList'] && ability['Expertise'].to_s.split('/').first.to_i == 1
                # Special case where SkList exists and expertise is 1
                client.emit_ooc "#{display_name}: #{ability['Flavor Text']} (#{ability['SkList']}). Tier #{tier}"
                else
                # Normal case without SkList or expertise other than 1
                client.emit_ooc "#{display_name}: #{ability['Flavor Text']} (Tier #{tier})"
                end
            end
            end
        
            # Display abilities with expertise of 1 first
            display_abilities.call(expertise_one_abilities)
        
            # Display abilities with expertise of 2 or more at the end
            expertise_two_or_more_abilities.each do |ability|
            ability_name = ability['Name']
            next unless ability_name # Skip abilities without a name
        
            ability_name_downcase = ability_name.downcase
            is_set = character_abilities.include?(ability_name_downcase)
            display_name = is_set ? "%xg#{ability_name}%xn" : "%xr#{ability_name}%xn"
        
            tier = ability['Tier'] || 'Unknown'
        
            # Display the ability name, status, and tier
            client.emit_ooc "#{display_name}: #{ability['Flavor Text']} (Tier #{tier})"
        
            # Now process SkList options only for abilities with expertise of 2 or more
            if ability['SkList']
                options_set = enactor.rr_specialabilities.to_a.find { |sa| sa.name.downcase == ability_name_downcase }
                selected_options = options_set&.sklist&.split(',')&.map(&:strip) || []
        
                expertise_limit = ability['Expertise'].split('/').first.to_i
                remaining_choices = expertise_limit - selected_options.size
        
                if selected_options.any?
                client.emit_ooc "Selected options: #{selected_options.join(', ')}"
                else
                client.emit_ooc "No options set yet."
                end
        
                # Show the appropriate message based on remaining choices
                if remaining_choices.positive?
                client.emit_ooc "You can select up to #{expertise_limit} options for #{ability_name} and have #{remaining_choices} choices remaining."
                client.emit_ooc "Use the command: rr/set/sa/#{ability_name_downcase}/[choice1],[choice2],..."
                else
                client.emit_ooc "You have selected the maximum allowed options."
                client.emit_ooc "Use rr/remove/sa/#{ability_name_downcase}/[choice] to remove a choice."
                end
            end
            end
        end

        def self.new_list_all_special_abilities(abilities, enactor, client, traits)
            if abilities.nil? || abilities.empty?
            #client.emit_failure "No special abilities available for #{traits.type.capitalize}."
            return
            end
        
            enactor.rr_specialabilities.each do |ability|
            #client.emit_ooc "Name: #{ability.name}, Tier: #{ability.tier}, Expertise: #{ability.expertise}, SkList: #{ability.sklist}"
            end
            # Prepare the template data and render

            selected_abilities= enactor.rr_specialabilities
            ability_name = "reach beyond"
            is_set = @selected_abilities.to_a.any? { |sa| sa.name.downcase == ability_name }
            template = RecursiveRealms::SpecialAbilitiesTemplate.new(abilities, enactor, traits)
            client.emit template.render
        end


        # Check if the character has already reached the maximum allowed moves
        if current_moves >= moves_allowed
            client.emit_failure "You have reached the maximum number of allowed moves (#{moves_allowed})."
            client.emit_ooc "Use rr/remove/moves to remove ALL moves"
            client.emit_ooc "Use rr/remove/moves/[move] to remove a specific moves"
            display_current_moves(enactor, client)
            return
          end
  
          # If no move name is given, show a list of available moves for the current tier
          if self.move_name.nil? || self.move_name.empty?
            move_list = moves.map { |move| move['Name'] }.join(", ")
            client.emit_ooc "Available Moves: #{move_list}"
            return
          end
  
          # If a move is given, find the move by name
          current_tier = traits.tier.to_i          
  
          moves = chartype['Tiers']
          .select { |key, _| key.match(/Tier (\d+)/) && $1.to_i <= current_tier }
          .map { |_, data| data['Moves'] || [] }
          .flatten
  
  
          move = moves.to_a.find { |m| m['Name'].downcase == self.move_name.downcase }
  
          if move.nil?
            client.emit_failure "Move'#{self.move_name}' not found."
            move_list = moves.map { |move| move['Name'] }.join(", ")
            client.emit_ooc "Available Moves: #{move_list}"
            return
          end
  
          # Add the move to the character's rr_moves collection
          RecursiveRealms.add_move(self.move_name, enactor, client)
  
        end
  
        def display_current_moves(enactor, client)
          if enactor.rr_moves.empty?
            client.emit_ooc "No moves set."
          else
            move_list = enactor.rr_moves.map { |move| move.name }.join(", ")
            client.emit_ooc "Current Moves: #{move_list}"
          end
        end        
    end 
end 
