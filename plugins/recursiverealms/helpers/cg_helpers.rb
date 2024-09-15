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

        # Helper method to add special abilities to the character's abilities
        def self.add_special_abilities(special_abilities, tier, enactor, client)
          special_abilities.each do |ability|
            # Check if the ability requires a user choice
            if ability['SkList'] && ability['SkList'].include?(',')
              # Prompt the user to make a choice (this can be handled with a separate command)
              client.emit_ooc "You must choose from the following options for #{ability['Name']}: #{ability['SkList']}."
              # This would trigger a flow to capture the user's choice
            else
              # Add the ability directly if no choice is needed
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