module AresMUSH
  module RecursiveRealms
    class SpecialAbilitiesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :abilities, :current_tier, :set_abilities, :unset_abilities

      def initialize(abilities, enactor, traits)
        @enactor = enactor
        @abilities = abilities
        @current_tier = traits.tier || 'Unknown'

        # Correctly map the ability names using the correct case for 'Name'
        @selected_abilities = enactor.rr_specialabilities

        super File.dirname(__FILE__) + "/cgen_type_sa_list.erb"

        # Categorize abilities into fully set and unset/incomplete
        #@set_abilities, @unset_abilities = categorize_abilities
      end

      def chartypetitle
        traits.type.capitalize
      end


    end
  end
end