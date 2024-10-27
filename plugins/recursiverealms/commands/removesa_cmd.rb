module AresMUSH
  module RecursiveRealms
    class RemoveSACmd
      include CommandHandler

      attr_accessor :tier, :ability_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)

        # Ensure we don't raise errors when not enough arguments are passed
        if split_switch.length > 2 && split_switch[2].match?(/^\d+$/)
          self.tier = split_switch[2].to_i
          self.ability_name = nil
        elsif split_switch.length > 2
          self.tier = nil
          self.ability_name = titlecase_arg(split_switch[2])
        else
          self.tier = nil
          self.ability_name = nil
        end
      end

      def handle
        abilities = enactor.rr_specialabilities

        client.emit_ooc "tier: #{tier}, Ability: #{ability_name}"

        if abilities.empty?
          client.emit_failure "You have no special abilities to remove."
          return
        end

        if self.ability_name
          # Remove the specific ability by name
          ability_to_remove = abilities.find { |ability| ability.name.downcase == self.ability_name.downcase }
          if ability_to_remove.nil?
            client.emit_failure "No special ability found with the name '#{self.ability_name}'."
          else
            abilities.delete(ability_to_remove)
            ability_to_remove.delete
            client.emit_success "The special ability '#{self.ability_name}' has been removed."
          end
        elsif self.tier
          # Remove only the special abilities for the specified tier
          abilities_to_remove = abilities.select { |ability| ability.tier.to_i == self.tier }

          if abilities_to_remove.empty?
            client.emit_failure "No special abilities found for Tier #{self.tier}."
          else
            abilities_to_remove.each { |ability| ability.delete }
            client.emit_success "All special abilities for Tier #{self.tier} have been removed."
          end
        else
          # Remove all special abilities if no tier or ability name is specified
          abilities.each { |ability| ability.delete }
          client.emit_success "All special abilities have been removed."
        end
      end
    end
  end
end
