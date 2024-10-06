module AresMUSH
  module RecursiveRealms
    class CharacterTypeFocusSummTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :focuses

      def initialize(enactor, chartype, focuses)
        @enactor = enactor
        @chartype = chartype
        @focuses = focuses
        @selected_focus = enactor.rr_traits.first&.focus&.downcase             
        super File.dirname(__FILE__) + "/character_type_focus_summ.erb"
      end

      def chartypetitle
        @chartype["Type"]
      end

      def focus_list
        @focuses.map do |focus|
          {
            name: focus["Focus"],
            description: focus["Description"] || "No description available",
            selected: focus["Focus"].downcase == @selected_focus
          }
        end
      end
    end
  end
end