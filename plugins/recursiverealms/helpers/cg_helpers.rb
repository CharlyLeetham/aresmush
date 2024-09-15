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
            client.emit_ooc "#{ability.inspect}"

            # Check if the ability already exists for the character
            existing_ability = enactor.rr_specialabilities.find { |a| a.name.downcase == ability['Name'].downcase }

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
    
    end
end        