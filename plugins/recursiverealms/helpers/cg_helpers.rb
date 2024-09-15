module AresMUSH
    module RecursiveRealms

        def handle_missing_type(client, enactor)
            client.emit_failure "Character type not provided. Please choose from one of the following available types:"
            list_all_types(client, enactor)
        end

        def handle_invalid_type(client, type, enactor)
            client.emit_failure "Character type '#{type.capitalize}' not found. Please choose from one of the following available types:"
            list_all_types(client, enactor)
        end

        def list_all_types(client, enactor)
            list_command = RecursiveRealms::ListAllTypesCmd.new(client, Command.new("recursiverealms.ListAllTypesCmd"), enactor)
            list_command.handle
        end
    end
end        