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
        moves = enactor.rr_moves

        if moves.empty?
          client.emit_failure "You have no moves to remove."
          return
        end

        if self.move_name.nil?
          # Remove all moves if no move name is specified
          moves.each { |move| move.delete }
          client.emit_success "All moves have been removed."
        else
          # Remove only the move with the specified name
          move_to_remove = moves.find { |move| move.name.downcase == self.move_name.downcase }

          if move_to_remove.nil?
            client.emit_failure "Move '#{self.move_name}' not found."
          else
            move_to_remove.delete
            client.emit_success "Move '#{self.move_name}' has been removed."
          end
        end
      end
    end
  end
end