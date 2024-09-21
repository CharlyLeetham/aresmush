module AresMUSH
  module RecursiveRealms
    class SetTierCmd
      include CommandHandler

      attr_accessor :value

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.value = split_switch[2] # Only the tier value is needed
      end

      def handle
        client.emit_ooc "Setting Tier to #{value}"

        if self.value.nil?
          return RecursiveRealms.handle_missing_type(client, enactor) 
        end 
        
        # Check if the tier is a valid number
        if !self.value || !self.value.is_integer? || self.value.to_i <= 0
          return client.emit_failure "Please provide a valid tier number."
        end   
        
        # Find or create the traits record
        traits = enactor.rr_traits.first
        if traits.nil?
          return client.emit_failure "You need to set a character type before you can adjust the tier."
        end

        # Update the tier in the character's traits
        traits.update(tier: self.value.to_i)
        client.emit_success "Your character's tier has been updated to #{self.value}."

        # Fetch the character type from the configuration
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == traits.type.downcase }

        if chartype.nil?
          return client.emit_failure "Character type '#{traits.type}' not found in the configuration."
        end

        # Update effort
        tier_key = "Tier #{self.value}"
        effort = chartype['Tiers'][tier_key]['Effort']
        if effort
          traits.update(effort: effort)
          client.emit_success "Effort for #{traits.type.capitalize} (Tier #{self.value}) has been set to #{effort}."
        else
          client.emit_success "Effort information for #{traits.type.capitalize} (Tier #{self.value}) does not change."
        end

        # Update Moves Allowed
        RecursiveRealms.update_moves_allowed(chartype, traits, self.value.to_i, client)

        # Add Special Abilities for the new tier
        special_abilities = chartype['Tiers'][tier_key]['Special Abilities']
        if special_abilities
          RecursiveRealms.add_special_abilities(special_abilities, self.value.to_i, enactor, client)
        end
      end
    end
  end
end