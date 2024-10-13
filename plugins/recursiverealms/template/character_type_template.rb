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
        
      # Check if the move is selected on the character
      def move_selected?(move_name)
        return false unless @enactor && @enactor.rr_moves

        # Debugging output
        Global.logger.debug "Checking move: #{move_name}"
        Global.logger.debug "Character's selected moves: #{@enactor.rr_moves.map(&:name).join(', ')}"

        # Check if the move is in the character's rr_moves collection
        @enactor.rr_moves.any? { |move| move.name.downcase == move_name.downcase }
      end

      # Highlight selected moves
      def highlight_moves(moves)
        Global.logger.debug "Entered Hightlight Moves"
        moves.map do |move|
          move_name = move['Name']
          Global.logger.debug "Move name 1: #{move_name}"
          if move_selected?(move_name)
            Global.logger.debug "Move name selected: #{move_name}"
            "%xg#{move_name}%xn"  # Highlight selected move in green
          else
            move_name
          end
        end.join(', ')
      end


      end
    end
  end