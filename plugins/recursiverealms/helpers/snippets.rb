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
              # client.emit_failure "No special abilities available for #{traits.type.capitalize}."
              return
          end

          enactor.rr_specialabilities.each do |ability|
              # client.emit_ooc "Name: #{ability.name}, Tier: #{ability.tier}, Expertise: #{ability.expertise}, SkList: #{ability.sklist}"
          end
          # Prepare the template data and render

          selected_abilities = enactor.rr_specialabilities
          ability_name = "reach beyond"
          is_set = selected_abilities.to_a.any? { |sa| sa.name.downcase == ability_name }
          template = RecursiveRealms::SpecialAbilitiesTemplate.new(abilities, enactor, traits)
          client.emit template.render
      end

      def self.add_move_old(move_name, enactor, client)
          # Define the logic for adding a move
      end

      def self.display_current_moves(enactor, client)
          if enactor.rr_moves.empty?
              client.emit_ooc "No moves set."
          else
              move_list = enactor.rr_moves.map { |move| move.name }.join(", ")
              client.emit_ooc "Current Moves: #{move_list}"
          end
      end

  end
end
