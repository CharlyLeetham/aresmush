module AresMUSH
  module RecursiveRealms
    class SpecialAbilitiesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :current_tier

      def initialize(abilities, enactor, traits)
        @enactor = enactor
        @abilities = abilities # Store the raw abilities
        @current_tier = traits.tier || 'Unknown'
        @traits = traits

        super File.dirname(__FILE__) + "/cgen_type_sa_list.erb"
      end

      def chartypetitle
        @traits.type.capitalize
      end

      # Return the transformed abilities
      def abilities
        @abilities.map do |ability|
          ability_name = ability["Name"].downcase
          is_set = @enactor.rr_specialabilities.any? { |sa| sa.name.downcase == ability_name }
          options_set = fetch_selected_options(ability_name)
          expertise_limit = ability["Expertise"] ? ability["Expertise"].split('/').first.to_i : 0
          remaining_choices = expertise_limit - options_set.size

          {
            name: ability["Name"],
            description: ability["Flavor Text"] || "No description available",
            sklist: ability["SkList"],
            selected_options: options_set,
            is_set: is_set,
            expertise_limit: expertise_limit,
            remaining_choices: remaining_choices,
            tier: ability["Tier"] || 'Unknown'
          }
        end
      end

      # Fetch selected options for an ability (if any)
      def fetch_selected_options(ability_name_downcase)
        ability_data = @enactor.rr_specialabilities.to_a.find { |sa| sa.name.downcase == ability_name_downcase }
        ability_data&.sklist&.split(',')&.map(&:strip) || []
      end
    end
  end
end