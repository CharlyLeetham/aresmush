module AresMUSH
  module RecursiveRealms
    class CharacterTypeFocusSummTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :focuses

      def initialize(enactor, chartype, focuses)
        @enactor = enactor
        @chartype = chartype
        @focuses = focuses

        client.emit_ooc "Focuses: #{@focuses.inspect}"        
        super File.dirname(__FILE__) + "/character_type_focus_summ.erb"
      end

      def chartypetitle
        @chartype["Type"]
      end

      def focus_list
        @focuses.map do |focus|
          {
            name: focus["Focus"],
            description: focus["Description"],
            equipment: focus["Equipment"] || "None",
            connection: focus["Connection"] || "None"
          }
        end
      end
    end
  end
end