module AresMUSH
  module RecursiveRealms

    def self.handle_missing_type(client, enactor)
      client.emit_failure "Character type not provided. Please choose from one of the available types:"
      list_all_types(client, enactor)
    end

    def self.handle_invalid_type(client, type, enactor)
      client.emit_failure "Character type '#{type.capitalize}' not found. Please choose from one of the available types:"
      list_all_types(client, enactor)
    end

    def self.list_all_types(client, enactor)
      list_command = RecursiveRealms::ListAllTypesCmd.new(client, Command.new("recursiverealms.ListAllTypesCmd"), enactor)
      list_command.handle
    end

    # Helper method to add or update special abilities for the character
    def self.add_special_abilities(special_abilities, tier, enactor, client)
      special_abilities.each do |ability|
        existing_ability = enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }
        
        if ability['SkList'] && ability['SkList'].include?(',')
          client.emit_ooc "Choose options for #{ability['Name']}: #{ability['SkList']}. Use the command rr/set/sa/#{ability['Name']}/option1,option2"
        else
          if existing_ability
            existing_ability.update(
              tier: tier,
              type: ability['Type'],
              expertise: ability['Expertise'],
              sklist: ability['SkList']
            )
            client.emit_success "Updated Special Ability: #{ability['Name']} (Tier #{tier})."
          else
            RRSpecialAbilities.create(
              character: enactor,
              name: ability['Name'],
              tier: tier,
              type: ability['Type'],
              expertise: ability['Expertise'],
              sklist: ability['SkList']
            )
            client.emit_success "Added Special Ability: #{ability['Name']} (Tier #{tier})."
          end
        end
      end
    end


    def self.list_unset_abilities_with_options(abilities, enactor, client)
      client.emit_ooc "Special Abilities that have unset options (SkList):"

      abilities.each do |ability|
        next unless ability['SkList']

        is_set = enactor.rr_specialabilities.find { |sa| sa.name.downcase == ability['Name'].downcase }
        unless is_set
          client.emit_ooc "#{ability['Name']} - #{ability['Flavor Text']}"
          client.emit_ooc "Options: #{ability['SkList']}"
        end
      end
    end

    # Helper method to list abilities that haven't been set and require options
    #def self.list_unset_abilities_with_options(special_abilities, enactor, client)
    #  abilities_to_select = special_abilities.select do |ability|
    #    ability['SkList'] && ability['SkList'].include?(',') &&
    #    !enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }
    #  end

    #  if abilities_to_select.empty?
    #    client.emit_ooc "All abilities with required selections have already been set."
    #  else
    #    ability_list = abilities_to_select.map { |ability| ability['Name'] }.join(", ")
    #    client.emit_ooc "Abilities requiring selection: #{ability_list}"
    #  end
    #end

    # Helper method to validate and set the chosen options for a special ability
    def self.set_special_ability_choices(ability, choices, expertise_limit, enactor, client, traits)
      selected_choices = choices.split(",").map(&:strip)
      if selected_choices.size > expertise_limit
        client.emit_failure "You can only choose up to #{expertise_limit} options for #{ability['Name']}."
        return
      end

      existing_ability = enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }

      if existing_ability
        existing_ability.update(sklist: selected_choices.join(", "))
      else
        RRSpecialAbilities.create(
          character: enactor,
          name: ability['Name'],
          tier: traits.tier,
          type: ability['Type'],
          expertise: ability['Expertise'],
          sklist: selected_choices.join(", ")
        )
      end
      client.emit_success "You have selected: #{selected_choices.join(", ")} for #{ability['Name']}."
    end

    def self.get_all_special_abilities_for_tier_and_below(chartype, current_tier)
      abilities_by_tier = []

      chartype['Tiers'].each do |tier_name, tier_data|
        tier_number = tier_name.split(' ').last.to_i
        if tier_number <= current_tier.to_i
          tier_abilities = tier_data['Special Abilities'] || []
          abilities_by_tier += tier_abilities
        end
      end

      abilities_by_tier
    end    

    def self.list_all_special_abilities(abilities, enactor, client, traits)
      if abilities.nil? || abilities.empty?
        client.emit_failure "No special abilities available for #{traits.type.capitalize}."
        return
      end
    
      client.emit_ooc "Available Special Abilities for #{traits.type.capitalize} (Current and Lower Tiers):"
    
      # Check if there are any special abilities set on the character
      if enactor.rr_specialabilities.nil? || enactor.rr_specialabilities.empty?
        client.emit_ooc "No special abilities are currently set on your character."
        character_abilities = []
      else
        # Track which abilities are set on the character
        character_abilities = enactor.rr_specialabilities.map(&:name).map(&:downcase)
        client.emit_ooc "Current Abilities: #{character_abilities.inspect}"
      end
    
      # Iterate over each ability, display its status and options
      abilities.each do |ability|
        client.emit_ooc "Test"
        is_set = character_abilities.include?(ability['Name'].downcase)
        client.emit_ooc "Test 2"        
        options_set = ability['SkList'] && enactor.rr_specialabilities.find { |sa| sa.name.downcase == ability['Name'].downcase }
    
        ability_status = is_set ? "%xg(SET)%xn" : "%xr(UNSET)%xn"
        client.emit_ooc "#{ability_status} #{ability['Name']} - #{ability['Flavor Text']}"
    
        # If the ability has options (SkList), display the options and whether they're set
        if ability['SkList']
          client.emit_ooc "Options: #{ability['SkList']}"
          if options_set && options_set.sklist
            client.emit_ooc "Selected options: #{options_set.sklist}"
          else
            client.emit_ooc "No options set yet."
          end
        end
      end
    end

    # Helper method to add a move to the character's moves
    def self.add_move(move_name, enactor, client)
      traits = enactor.rr_traits.first
      if traits.nil?
        client.emit_failure "Character traits not found."
        return
      end

      chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
      if chartype.nil?
        client.emit_failure "Character type '#{traits.type}' not found in configuration."
        return
      end

      tier_key = "Tier #{traits.tier}"
      moves = chartype['Tiers'][tier_key]['Moves']
      if moves.nil?
        client.emit_failure "Moves not found for Tier #{traits.tier}."
        return
      end

      move = moves.find { |m| m['Name'].downcase == move_name.downcase }
      if move.nil?
        client.emit_failure "Move '#{move_name}' not found."
        return
      end

      # Check if the move already exists for the character
      existing_move = enactor.rr_moves.to_a.find { |m| m.name.downcase == move['Name'].downcase }
      if existing_move
        client.emit_failure "Move '#{move_name}' has already been added."
        # Call the function to display current moves status
        RecursiveRealms.emit_moves_status(enactor, client)
        return
      end

      # Add the move to the character's rr_moves collection
      RRMoves.create(
        character: enactor,
        name: move['Name'],
        tier: traits.tier,
        type: move['Type'],
        modifier: move['Modifier'],
        cost: move['Cost'],
        duration: move['Duration']
      )

      # Call the function to display current moves status after the move is added
      RecursiveRealms.emit_moves_status(enactor, client)
    end


    # Helper method to calculate and emit the current move status
    def self.emit_moves_status(enactor, client)
      traits = enactor.rr_traits.first
      if traits.nil?
        client.emit_failure "Character traits not found."
        return
      end

      moves_allowed = (traits.moves || 0).to_i
      current_moves = enactor.rr_moves.size
      remaining_moves = moves_allowed - current_moves

      client.emit_ooc "Moves allowed: #{moves_allowed}, Current moves: #{current_moves}, Remaining moves: #{remaining_moves}"

      if remaining_moves > 0
        # List the available moves from all tiers they have access to
         available_moves = list_available_moves(traits, enactor)
        client.emit_success "You have #{remaining_moves} move(s) remaining."
        if available_moves.empty?
          client.emit_ooc "No additional moves are available for selection."
        else
          client.emit_ooc "Available moves: #{available_moves.join(', ')}"
        end
      else
        client.emit_failure "You have reached the maximum number of moves."
      end
    end 
    
    # Helper method to list available moves from all accessible tiers, excluding chosen ones
    def self.list_available_moves(traits, enactor)
      # Retrieve the character's type from the traits
      chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
      return [] if chartype.nil?

      available_moves = []
      current_moves = enactor.rr_moves.to_a.map(&:name).map(&:downcase)

      # Iterate through all tiers up to the current tier
      (1..traits.tier.to_i).each do |tier|
        tier_key = "Tier #{tier}"
        moves = chartype['Tiers'][tier_key] ? chartype['Tiers'][tier_key]['Moves'] : []

        # Add only the moves that haven't been chosen yet
        available_moves.concat(moves.select { |m| !current_moves.include?(m['Name'].downcase) }.map { |m| m['Name'] })
      end

      available_moves
    end    

    # Helper method to update moves allowed based on current tier
    def self.update_moves_allowed(chartype, traits, current_tier, client)
      moves_allowed_total = 0

      (1..current_tier).each do |tier|
        tier_key = "Tier #{tier}"
        moves_allowed_for_tier = chartype['Tiers'][tier_key] ? chartype['Tiers'][tier_key]['Moves Allowed'] : nil

        if moves_allowed_for_tier
          moves_allowed_total += moves_allowed_for_tier
        else
          client.emit_ooc "Moves Allowed for #{traits.type.capitalize} (Tier #{tier}) not found. Skipping."
        end
      end

      traits.update(moves: moves_allowed_total)
      client.emit_success "Total allowed moves for #{traits.type.capitalize} (up to Tier #{current_tier}) set to #{moves_allowed_total}."
    end

    # Handle the case when the move_name is missing
    def self.handle_missing_move(moves, enactor, client)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil? || traits.type.nil?
        client.emit_failure "Character type not set. Please set a character type first."
        return
      end    
      # Call the function to list all available moves
      list_all_moves(client, enactor)
    end    
    
    def self.list_all_moves(client, enactor)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil?
        client.emit_failure "Character traits not found."
        return
      end
      
      # Fetch character type from the YAML configuration
      chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
      if chartype.nil?
        client.emit_failure "Character type '#{traits.type}' not found in the configuration."
        return
      end
    
      # Retrieve the current tier and number of moves
      current_tier = traits.tier
      num_moves = traits.moves
    
      # Get the moves for the current tier
      tier_key = "Tier #{current_tier}"
      tier_data = chartype['Tiers'][tier_key]
    
      if tier_data && tier_data['Moves']
        # Pass the moves data to the template for rendering
        template = CharacterTypeMovesSummTemplate.new(enactor, chartype, current_tier, num_moves)
        client.emit template.render
      else
        client.emit_failure "Moves not found for Tier #{current_tier} for character type #{traits.type.capitalize}."
      end
    end    


    def self.handle_missing_focus(chartype, enactor, client)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil? || traits.type.nil?
        client.emit_failure "Character type not set. Please set a character type first."
        return
      end

      # Call the function to list all available focuses
      list_all_focuses(client, enactor)
    end

    def self.list_all_focuses(client, enactor)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil?
        client.emit_failure "Character traits not found."
        return
      end

      # Get the character type from the traits
      character_type = traits.type.downcase

      # Fetch all available focuses from the YAML configuration
      focuses = Global.read_config("RecursiveRealms", "focuses")

      # Pass descriptors to the template
      template = CharacterTypeFocusSummTemplate.new(enactor, character_type, focuses)
      client.emit template.render      
    end

    def self.handle_missing_descriptor(chartype, enactor, client)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil? || traits.type.nil?
        client.emit_failure "Character type not set. Please set a character type first."
        return
      end
    
      # Call the function to list all available descriptors
      list_all_descriptors(client, enactor)
    end    

    def self.list_all_descriptors(client, enactor)
      # Retrieve character traits
      traits = enactor.rr_traits.first
      if traits.nil?
        client.emit_failure "Character traits not found."
        return
      end
    
      # Fetch all available descriptors from the YAML configuration
      descriptors = Global.read_config("RecursiveRealms", "descriptors")

      # Get the character type from the traits
      character_type = traits.type.downcase

      # Pass descriptors to the template
      template = CharacterTypeDescriptorSummTemplate.new(enactor, character_type, descriptors)
      client.emit template.render      
  
    end    

  end
end