module AresMUSH
  module RecursiveRealms
    class SetMovesCmd
      include CommandHandler

      attr_accessor :move_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)

        # Ensure we don't raise errors when not enough arguments are passed
        self.move_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the move
      end

      def handle
        client.emit_ooc "#{move_name}"

        # Retrieve character type and tier from their traits
        traits = enactor.rr_traits.first
        if traits.nil?
          client.emit_failure "Character traits not found."
          return
        end        

        # Retrieve the moves from the YAML based on character type and tier
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in configuration."
          return
        end

        tier_key = "Tier #{traits.tier}"
        moves = chartype['Tiers'][tier_key]['Moves']

        client.emit_ooc "#{move_name.inspect}"

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
          return
        end

        # Add the move to the character's rr_moves collection
        RecursiveRealms.add_move(self.move_name, enactor, client)
      end
    end
  end
end