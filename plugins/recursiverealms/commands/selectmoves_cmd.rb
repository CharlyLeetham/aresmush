module AresMUSH
    module RecursiveRealms
      class SelectMovesCmd
        include CommandHandler
  
        def handle
          # Get character traits
          traits = enactor.rr_traits.first
          if traits.nil?
            client.emit_failure "Character traits not found."
            return
          end
  
          # Check if character type is set
          if traits.type.nil?
            client.emit_failure "Your character type is not set. Please set a character type first."
            return
          end
  
          # Retrieve the available moves based on character type and tier
          chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }
          if chartype.nil?
            client.emit_failure "Character type '#{traits.type}' not found in configuration."
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