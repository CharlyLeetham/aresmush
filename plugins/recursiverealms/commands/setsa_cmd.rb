module AresMUSH
    module RecursiveRealms
      class SetSACmd
        include CommandHandler
  
        attr_accessor :ability_name, :choices
  
        def parse_args
          split_switch = RecursiveRealms.multi_split_command(@cmd)
          self.ability_name = split_switch[1] # The name of the special ability
          self.choices = split_switch[2]      # The user choices, can be comma-separated
        end
  
        def handle
          client.emit_ooc "#{ability_name}, #{choices}"
  
          # Find the special ability by name
          ability = enactor.rr_specialabilities.find { |a| a.name.downcase == self.ability_name.downcase }
          if ability.nil?
            client.emit_failure "Special Ability '#{self.ability_name}' not found."
            return
          end
  
          # Determine how many options can be chosen based on the Expertise value
          expertise_limit = ability.expertise.split('/').first.to_i
  
          # Split and validate user choices
          selected_choices = self.choices.split(",").map(&:strip)
          if selected_choices.size > expertise_limit
            client.emit_failure "You can only choose up to #{expertise_limit} options for #{ability.name}. You selected #{selected_choices.size}."
            return
          end
  
          # If valid, update the sklist with the chosen selections (comma-separated)
          ability.update(sklist: selected_choices.join(", "))
          client.emit_success "You have selected: #{selected_choices.join(", ")} for #{ability.name}."
        end
      end
    end
 end        