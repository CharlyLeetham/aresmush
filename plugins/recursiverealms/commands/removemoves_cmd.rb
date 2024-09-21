module AresMUSH
  module RecursiveRealms
    class RemoveMovesCmd
      include CommandHandler

      attr_accessor :move_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)

        # Ensure we don't raise errors when not enough arguments are passed
        self.move_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the move, if provided
      end

      def handle
        moves = enactor.rr_moves.to_a # Convert the moves collection to an array for easier manipulation
        if moves.empty?
          client.emit_failure "You have no moves to remove."
          return
        end

        if self.move_name.nil?
          # If no move_name is provided, remove all moves
          moves.each do |move|
            move.delete # Ohm method to delete the move object
          end
          client.emit_success "All moves have been removed."
          # Re-emit the current moves status after removal
          RecursiveRealms.emit_moves_status(enactor, client)
        else
          # Find and remove the move by name
          move_to_remove = moves.find { |m| m.name.downcase == self.move_name.downcase }

          if move_to_remove.nil?
            client.emit_failure "Move '#{self.move_name}' not found."
          else
            move_to_remove.delete
            client.emit_success "Move '#{self.move_name}' has been removed."
            # Re-emit the current moves status after the move is removed
            RecursiveRealms.emit_moves_status(enactor, client)
          end
        end
      end
    end
  end
end