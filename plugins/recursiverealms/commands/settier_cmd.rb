module AresMUSH
  module RecursiveRealms
    class SetTierCmd
      include CommandHandler

      attr_accessor :value, :target_name

      def check_permission
        return t('dispatcher.not_allowed') if !RecursiveRealms.can_manage_apps?(enactor)
        return nil
      end

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(cmd)
        self.value = split_switch[2] # The tier value
        self.target_name = split_switch.length > 3 ? split_switch[3] : enactor_name  #character_name      
      end      

      def handle
        # Find the target character (default to enactor if no name is provided)
        result = ClassTargetFinder.find(self.target_name, Character, enactor)

        if result.error
          client.emit_failure "Error: #{result.error}"
          return
        end

        traits = result.target.rr_traits.first
        client.emit_ooc "#{traits.inspect}"

        if traits.nil?
          client.emit_failure "#{result.target.name} needs to set a character type before adjusting the tier."
          return
        end

        # Update the tier
        if !self.value.is_integer? || self.value.to_i <= 0
          client.emit_failure "Please provide a valid tier number."
          return
        end

        traits.update(tier: self.value.to_i)
        client.emit_success "#{result.target.name}'s tier has been updated to #{self.value}."

        # Fetch and update character details based on type
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].casecmp(traits.type).zero? }
        if chartype.nil?
          client.emit_failure "Character type '#{traits.type}' not found in the configuration."
          return
        end

        # Update Effort
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
          RecursiveRealms.add_special_abilities(special_abilities, self.value.to_i, result.target, client)
        end
      end
    end
  end
end