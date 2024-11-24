module AresMUSH
  module RecursiveRealms
    class RRSheetCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(cmd)
        self.target_name = split_switch.length > 1 ? split_switch[1] : enactor_name

      end

      def handle

        if target_name.nil?
          client.emit_ooc "Character '#{target_name}' not found."
          return
        end  

        # Find the target character (default to enactor if no name is provided)
        result = ClassTargetFinder.find(self.target_name, Character, enactor)

        # Fetch and display the character's rr_traits
        traits = result.target.rr_traits.first
        if traits
          traits = result.target.rr_traits.first

          if traits
            # Pass the character's traits, special abilities, and moves to the template
            template = RRSheetTemplate.new(traits, result.target.rr_specialabilities, result.target.rr_moves, result.target)
            client.emit template.render
          else
            client.emit_ooc "Character type configuration not found in the YAML file."
          end
        else
          client.emit_ooc "No traits assigned. Please type rr/set/type/[type] to begin your character creation."
          return RecursiveRealms.handle_missing_type(client, result.target)
        end
      end
    end
  end
end