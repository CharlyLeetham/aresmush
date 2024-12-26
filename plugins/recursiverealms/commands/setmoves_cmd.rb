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
        # If no move name is given, call the helper function and list available moves

        if self.move_name.nil? || self.move_name.empty?
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

          # Call the helper function to show available moves
          RecursiveRealms.handle_missing_move(moves, enactor, client)
          return
        end

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
  
        current_tier = traits.tier.to_i
        total_moves_allowed = RecursiveRealms.calculate_total_moves(chartype, current_tier)
        tier_moves_allowed = RecursiveRealms.calculate_moves_per_tier(chartype, current_tier)

        # Display move limits dynamically
        if self.move_name.nil? || self.move_name.empty?
          client.emit_ooc "You have used #{enactor.rr_moves.size}/#{total_moves_allowed} total moves."
          tier_moves_allowed.each do |tier, allowed|
            tier_moves_count = enactor.rr_moves.select { |m| m.tier == tier.match(/\d+/)[0].to_i }.size
            client.emit_ooc "Tier #{tier.match(/\d+/)[0]}: #{tier_moves_count}/#{allowed} moves."
          end
          RecursiveRealms.handle_missing_move(traits.type, enactor, client)
          return
        end

        # Check if the character has already reached the maximum allowed moves
        if enactor.rr_moves.size >= total_moves_allowed
          client.emit_failure "You have reached the maximum number of allowed moves (#{total_moves_allowed})."
          display_current_moves(enactor, client)
          return
        end

        # Retrieve available moves for all tiers up to the current tier
        moves = chartype['Tiers']
          .select { |key, _| key.match(/Tier (\d+)/) && $1.to_i <= current_tier }
          .map { |_, data| data['Moves'] || [] }
          .flatten

        move = moves.to_a.find { |m| m['Name'].downcase == self.move_name.downcase }

        if move.nil?
          client.emit_failure "Move '#{self.move_name}' not found."
          move_list = moves.map { |move| move['Name'] }.join(", ")
          client.emit_ooc "Available Moves: #{move_list}"
          return
        end

        # Check tier-specific move limits
        move_tier = move['Tier'] || current_tier
        tier_limit = tier_moves_allowed["Tier #{move_tier}"]
        tier_moves_count = enactor.rr_moves.select { |m| m.tier == move_tier }.size

        if tier_moves_count >= tier_limit
          client.emit_failure "You have reached the maximum number of moves for Tier #{move_tier} (#{tier_limit})."
          return
        end

        # Add the move to the character's rr_moves collection
        RecursiveRealms.add_move(self.move_name, enactor, client)
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