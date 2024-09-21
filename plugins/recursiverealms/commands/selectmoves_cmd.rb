module AresMUSH
    module RecursiveRealms
      class SelectMovesCmd
        include CommandHandler
  
        def handle
          traits = enactor.rr_traits.first
          if traits.nil?
            client.emit_failure "Character traits not found."
            return
          end
  
          # Retrieve the available moves based on character type and tier
          chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
          if chartype.nil?
            client.emit_failure "Character type '#{traits.type}' not found in configuration."
            client.emit_failure "Use rr/set/type/[type] to start CGen"
            return
          end
  
          tier_key = "Tier #{traits.tier}"
          moves = chartype['Tiers'][tier_key]['Moves']
  
          if moves.nil? || moves.empty?
            client.emit_failure "No moves available for your character."
          else
            move_list = moves.map { |m| m['Name'] }.join(", ")
            client.emit_ooc "Available moves: #{move_list}"
          end
        end
      end
    end
  end