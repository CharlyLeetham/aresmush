module AresMUSH
  module RecursiveRealms
    class RRResetCmd
      include CommandHandler

      def handle
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "No traits found to reset."
          return
        end

        # Confirm with the user before proceeding
        if !enactor.has_confirmed_reset
          client.emit_ooc "This will reset your character's type, tier, abilities, moves, and other attributes. Type 'yes' to confirm."
          enactor.update(has_confirmed_reset: true) # Track that they've been prompted
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

        # Clear confirmation flag
        enactor.update(has_confirmed_reset: false)

        client.emit_success "Your character has been reset to a default state."
      end
    end
  end
end