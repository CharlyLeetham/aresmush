module AresMUSH
  module RecursiveRealms
    class SetMovesCmd
      include CommandHandler

      attr_accessor :move_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.move_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the move
      end

      def handle
        client.emit_ooc "Move: #{move_name}"

        # Retrieve character traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end

        # Retrieve character type and tier from the YAML
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in configuration."
          return
        end

        tier_key = "Tier #{traits.tier}"
        moves = chartype['Tiers'][tier_key]['Moves']

        # Error handling for when Moves does not exist
        if moves.nil? || moves.empty?
          client.emit_failure "No moves are available for #{traits.type.capitalize} at Tier #{traits.tier}."
          return
        end

        # Retrieve the allowed number of moves
        moves_allowed = traits.moves || 0
        current_moves = enactor.rr_moves.size

        # Check if the character has already reached the maximum allowed moves
        if current_moves >= moves_allowed
          client.emit_failure "You have reached the maximum number of allowed moves (#{moves_allowed})."
          display_current_moves(enactor, client)
          return
        end

        # If no move name is given, show a list of available moves for the current tier
        if self.move_name.nil? || self.move_name.empty?
          move_list = moves.map { |move| move['Name'] }.join(", ")
          client.emit_ooc "Available Moves: #{move_list}"
          return
        end

        # Find the move by name
        move = moves.find { |m| m['Name'].downcase == self.move_name.downcase }

        if move.nil?
          client.emit_failure "Move '#{self.move_name}' not found."
          move_list = moves.map { |move| move['Name'] }.join(", ")
          client.emit_ooc "Available Moves: #{move_list}"
          return
        end

        # Add the move to the character's rr_moves collection
        RecursiveRealms.add_move(self.move_name, enactor, client)

        # Display how many moves the character has left
        remaining_moves = moves_allowed - (current_moves + 1)
        client.emit_success "Move '#{self.move_name}' has been added. You have #{remaining_moves} moves remaining."

        # Display current moves
        display_current_moves(enactor, client)
      end

      def display_current_moves(enactor, client)
        if enactor.rr_moves.empty?
          client.emit_ooc "No moves set."
        else
          move_list = enactor.rr_moves.map { |move| move.name }.join(", ")
          client.emit_ooc "Current Moves: #{move_list}"
        end
      end
    end
  end
end