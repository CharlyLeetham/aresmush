module AresMUSH
  module RecursiveRealms

    def self.handle_missing_type(client, enactor)
      client.emit_failure "Character type not provided. Please choose from one of the following available types:"
      list_all_types(client, enactor)
    end

    def self.handle_invalid_type(client, type, enactor)
      client.emit_failure "Character type '#{type.capitalize}' not found. Please choose from one of the following available types:"
      list_all_types(client, enactor)
    end

    def self.list_all_types(client, enactor)
      list_command = RecursiveRealms::ListAllTypesCmd.new(client, Command.new("recursiverealms.ListAllTypesCmd"), enactor)
      list_command.handle
    end

    # Helper method to add or update special abilities for the character
    def self.add_special_abilities(special_abilities, tier, enactor, client)
      special_abilities.each do |ability|
        # Check if the ability already exists for the character
        existing_ability = enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }
        if ability['SkList'] && ability['SkList'].include?(',')
          # If the ability requires a choice from the SkList, prompt the user for input
          client.emit_ooc "You must choose from the following options for #{ability['Name']}: #{ability['SkList']}."
          # Add logic to capture the user's choice here
        else
          if existing_ability
            # Update the existing ability
            existing_ability.update(
              tier: tier,
              type: ability['Type'],
              expertise: ability['Expertise'],
              sklist: ability['SkList']
            )
            client.emit_success "Updated Special Ability: #{ability['Name']} (Tier #{tier})."
          else
            # Create a new ability if it doesn't already exist
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
        # Ability should have options in SkList and should not already be set
        ability['SkList'] && ability['SkList'].include?(',') &&
        !enactor.rr_specialabilities.to_a.find { |a| a.name.downcase == ability['Name'].downcase }
      end

      if abilities_to_select.empty?
        client.emit_ooc "All abilities with required selections have already been set."
      else
        ability_list = abilities_to_select.map { |ability| ability['Name'] }.join(", ")
        client.emit_ooc "Abilities that require options and haven't been set: #{ability_list}"
      end
    end

    # Helper method to validate and set the chosen options for a special ability
    def self.set_special_ability_choices(ability, choices, expertise_limit, enactor, client, traits)
      # Split and validate user choices
      selected_choices = choices.split(",").map(&:strip)
      if selected_choices.size > expertise_limit
        client.emit_failure "You can only choose up to #{expertise_limit} options for #{ability['Name']}. You selected #{selected_choices.size}."
        return
      end

      # Update or create the ability record in the database for the character
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

  end
end
