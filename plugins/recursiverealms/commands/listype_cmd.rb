module AresMUSH
  module RecursiveRealms
    class ListTypeCmd
      attr_accessor :detail

      def initialize(detail)
        @detail = detail  
      end
      
      def handle
        chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @detail }
        if chartype
              template = CharacterTypeTemplate.new(chartype)
              client.emit template.render
        else
          @client.emit_failure "Character type not found."
        end
      end     
    end
  end
end
