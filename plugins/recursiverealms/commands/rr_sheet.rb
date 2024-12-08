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
        # Find the target character (default to enactor if no name is provided)
        result = ClassTargetFinder.find(self.target_name, Character, enactor)

        if result.error
          client.emit_ooc "Error: #{result.error}"
          return
        end

        # Fetch and display the character's rr_traits
        traits = result.target.rr_traits.first

        #Testing


        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['ID'] == traits.type }
        client.emit_ooc "RRTraits: #{traits.type}"
        currenttier = traits.tier.to_i
        nummoves = RecursiveRealms.calculate_total_moves(chartype, currenttier)

        client.emit_ooc "Type: #{chartype}, nummoves: #{nummoves}"

        if traits
          # Pass the character's traits, special abilities, and moves to the template
          template = RRSheetTemplate.new(traits, result.target.rr_specialabilities, result.target.rr_moves, result.target)
          client.emit template.render
        else
          client.emit_ooc "#{result.target.name} has no Type assigned yet. Please type `rr/set/type/[type]` to begin your character creation."
          RecursiveRealms.handle_missing_type(client, result.target)
        end
      end
    end
  end
end
