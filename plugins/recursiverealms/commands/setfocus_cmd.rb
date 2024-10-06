module AresMUSH
  module RecursiveRealms
    class SetFocusCmd
      include CommandHandler

      attr_accessor :focus_name

      def parse_args
        split_switch = RecursiveRealms.multi_split_command(@cmd)
        self.focus_name = split_switch.length > 2 ? split_switch[2] : nil # The name of the focus
      end

      def handle
        # If no focus name is given, list available focuses
        if self.focus_name.nil? || self.focus_name.empty?
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

          # Fetch available focuses for the character type and current tier and below
          RecursiveRealms.list_available_focuses(chartype, traits.tier, client)
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

        tier_key = "Tier #{traits.tier}"

        # Fetch the available focuses for the tier
        focuses = Global.read_config("RecursiveRealms", "focuses")
        focus = focuses.find { |f| f['Focus'].downcase == self.focus_name.downcase }

        if focus.nil?
          client.emit_failure "Focus '#{self.focus_name}' not found."
          available_focuses = focuses.map { |f| f['Focus'] }.join(", ")
          client.emit_ooc "Available Focuses: #{available_focuses}"
          return
        end

        # Check if the character already has a focus
        if enactor.rr_traits.first.focus
          client.emit_failure "You already have a focus: #{enactor.rr_traits.first.focus.capitalize}. You must clear it first before setting a new focus."
          return
        end

        # Assign the focus to the character
        traits.update(focus: self.focus_name)
        client.emit_success "Your focus has been set to #{self.focus_name.capitalize}."

      end
    end
  end
end