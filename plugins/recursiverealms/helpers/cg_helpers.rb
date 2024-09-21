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

    # Helper method to list abilities that haven't been set and require options
    def self.list_unset_abilities_with_options(special_abilities, enactor, client)
      abilities_to_select = special_abilities.select do |ability|
        ability['SkList'] && ability['SkList'].include?(',') &&
        !enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }
      end

      if abilities_to_select.empty?
        client.emit_ooc "All abilities with required selections have already been set."
      else
        ability_list = abilities_to_select.map { |ability| ability['Name'] }.join(", ")
        client.emit_ooc "Abilities requiring selection: #{ability_list}"
      end
    end

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
        client.emit_success "You have #{remaining_moves} move(s) remaining."
      else
        client.emit_failure "You have reached the maximum number of moves."
      end
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
  end
end