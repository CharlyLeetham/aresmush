module AresMUSH
  module RecursiveRealms
    class CharacterTypeTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          super File.dirname(__FILE__) + "/character_type.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

        # Build the move details string with conditional fields
        def build_move_details(move)
          details = []
          
          details << "%xhType:%xn #{move['Type']}" if move['Type']
          details << "%xhDuration:%xn #{move['Duration']}" if move['Duration']
          details << "%xhCost:%xn #{move['Cost']}" if move['Cost']
          details << "%xhModifier:%xn #{move['Modifier']}" if move['Modifier']
          
          # Join the details with commas and wrap them in parentheses
          details.empty? ? "" : " (" + details.join(", ") + ")"
        end        

      end
    end
  end