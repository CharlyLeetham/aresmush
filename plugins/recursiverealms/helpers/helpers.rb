module AresMUSH
    module RecursiveRealms

        def self.split_command(cmd)
            split_switch = cmd.raw.split('/', 4).reject(&:empty?)    
            arg1 = split_switch.length > 1 ? split_switch[1] : nil
            arg2 = split_switch.length > 2 ? split_switch[2] : nil
            arg3 = split_switch.length > 3 ? split_switch[3] : nil
           return [arg1, arg2, arg3]
        end

        def self.multi_split_command(cmd)
            split_switch = cmd.raw.split('/').reject(&:empty?)
            return split_switch[1..-1] # Return all arguments except the first (which is typically the command root)
        end

        def self.can_manage_apps?(actor)
            actor && actor.has_permission?("manage_apps")
        end  

        # Calculate the total number of moves up to the given tier
        def self.calculate_total_moves(chartype, current_tier)
            total_moves = 0
                            
            (1..current_tier.to_i).each do |tier|
              Global.logger.debug "totalmoves 2 Tier level #{tier}."                   
              tier_key = "Tier #{tier}"
              Global.logger.debug "Totalmoves 2 Tier key #{tier_key}." 
              Global.logger.debug "Tier key comparison: #{tier_key} vs #{chartype['Tiers'].keys.first}"               
              moves_allowed_for_tier = chartype['Tiers'][tier_key] ? chartype['Tiers'][tier_key]['Moves Allowed'] : 0
        
              total_moves += moves_allowed_for_tier
            end
        
            total_moves
        end
        
        # Calculate the number of moves for each tier up to the current tier
        def self.calculate_moves_per_tier(chartype, current_tier)
        tier_moves = {}
    
        (1..current_tier.to_i).each do |tier|
            tier_key = "Tier #{tier}"
            moves_allowed_for_tier = chartype['Tiers'][tier_key] ? chartype['Tiers'][tier_key]['Moves Allowed'] : 0
    
            tier_moves[tier_key] = moves_allowed_for_tier
        end
    
        tier_moves
        end
        
        # General helper to display moves dynamically
        def self.display_moves(chartype, current_tier, client)
            total_moves = calculate_total_moves(chartype, current_tier)
            tier_moves = calculate_moves_per_tier(chartype, current_tier)

            # Emit total moves message
            client.emit_success "Total allowed moves up to Tier #{current_tier}: #{total_moves}."

            # Emit moves per tier messages
            tier_moves.each do |tier, moves|
            client.emit_success "Moves for #{tier}: #{moves}."
            end
        end        
        
    end
end
