module AresMUSH
  module RecursiveRealms
    class RemoveMovesCmd
      include CommandHandler

      attr_accessor :tier

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        client.emit_ooc "#{split_switch.inspect}"

        # Ensure we don't raise errors when not enough arguments are passed
        self.tier = split_switch.length > 2 ? split_switch[2].to_i : nil
        client.emit_ooc "#{tier}"
      end

      def handle
        moves = enactor.rr_moves

        if moves.empty?
          client.emit_failure "You have no moves to remove."
          return
        end

        if self.tier.nil?
          # Remove all moves if no tier is specified
          moves.each { |move| move.delete }
          client.emit_success "All moves have been removed."
        else
          # Remove only the moves for the specified tier
          moves_to_remove = moves.select { |move| move.tier.to_i == self.tier }

          if moves_to_remove.empty?
            client.emit_failure "No moves found for Tier #{self.tier}."
          else
            moves_to_remove.each { |move| move.delete }
            client.emit_success "All moves for Tier #{self.tier} have been removed."
          end
        end
      end
    end
  end
end