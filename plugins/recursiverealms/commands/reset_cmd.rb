module AresMUSH
  module RecursiveRealms
    class RRResetCmd
      include CommandHandler

      def handle
        # Check if the user typed 'yes' as a confirmation
        if cmd.args == "yes"
          reset_character
        else
          client.emit_ooc "This will reset your character's type, tier, abilities, moves, and other attributes. Type 'rr/reset yes' to confirm."
        end
      end

      def reset_character
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "No traits found to reset."
          return
        end

        # Reset the character's traits
        traits.update(
          type: nil,
          tier: nil,
          effort: nil,
          moves: nil,
          xp: 0
        )

        # Remove special abilities
        enactor.rr_specialabilities.each(&:delete)

        # Remove moves
        enactor.rr_moves.each(&:delete)

        client.emit_success "Your character has been reset to a blank state."
      end
    end
  end
end