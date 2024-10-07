module AresMUSH
  module RecursiveRealms
    class RRSheetCmd
      include CommandHandler

      def handle
        # Fetch and display the character's rr_traits
        traits = enactor.rr_traits.first
        if traits
          traits = enactor.rr_traits.first
          if traits
            # Pass the character's traits, special abilities, and moves to the template
            template = RRSheetTemplate.new(traits, enactor.rr_specialabilities, enactor.rr_moves)
            client.emit template.render
          else
            client.emit_ooc "Character type configuration not found in the YAML file."
          end
        else
          client.emit_ooc "No traits assigned. Please type rr/set/type/[type] to begin your character creation."
          return RecursiveRealms.handle_missing_type(client, enactor)
        end
      end
    end
  end
end