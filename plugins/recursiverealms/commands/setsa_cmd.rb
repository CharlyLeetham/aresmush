module AresMUSH
    module RecursiveRealms
      class SetSACmd
        include CommandHandler
  
        attr_accessor :topcmd, :type, :value, :tier
  
        def parse_args
          split_switch = RecursiveRealms.split_command(@cmd)
          self.topcmd = split_switch[0]
          self.type = split_switch[1]
          self.value = split_switch[2]
        end
  
        def handle
         client.emit_ooc "#{topcmd}, #{type}, #{value}"
          # Find the special ability by name
#=begin
          ability = enactor.rr_specialabilities.find { |a| a.name.downcase == self.value.downcase }
          if ability.nil?
            client.emit_failure "Special Ability '#{self.value}' not found."
            return
          end
  
          # Determine how many options can be chosen based on the Expertise value
          expertise_limit = ability.expertise.split('/').first.to_i
  
          # Validate that the number of choices does not exceed the expertise limit
          selected_choices = self.choices.split(",").map(&:strip)
          if selected_choices.size > expertise_limit
            client.emit_failure "You can only choose up to #{expertise_limit} options for #{ability.name}. You selected #{selected_choices.size}."
            return
          end
  
          # If valid, update the sklist with the chosen selections (comma-separated)
          ability.update(sklist: selected_choices.join(", "))
          client.emit_success "You have selected: #{selected_choices.join(", ")} for #{ability.name}."
#=end
        end
      end
    end
 end        