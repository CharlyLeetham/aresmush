module AresMUSH
  module RecursiveRealms
    class SpecialAbilitiesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :abilities, :current_tier, :set_abilities, :unset_abilities

      def initialize(abilities, enactor, traits)
        @enactor = enactor
        @abilities = abilities
        @current_tier = traits.tier || 'Unknown'
        @selected_abilities = enactor.rr_specialabilities

        super File.dirname(__FILE__) + "/cgen_type_sa_list.erb"

        # Categorize abilities into fully set and unset/incomplete
        @set_abilities, @unset_abilities = categorize_abilities
      end

      def chartypetitle
        traits.type.capitalize
      end

      # Sort abilities into fully set and unset/incomplete categories
      def categorize_abilities
        fully_set = []
        unset_or_incomplete = []

        @abilities.each do |ability|
          ability_name = ability["Name"].downcase
          is_set = @selected_abilities.include?(ability_name)

          expertise_limit = ability["Expertise"] ? ability["Expertise"].split('/').first.to_i : 0
          options_set = fetch_selected_options(ability_name)
          remaining_choices = expertise_limit - options_set.size

          # If it's set and all choices are selected, it's fully set
          if is_set && remaining_choices <= 0
            fully_set << format_ability(ability, options_set, true, remaining_choices)
          else
            unset_or_incomplete << format_ability(ability, options_set, false, remaining_choices)
          end
        end

        return fully_set, unset_or_incomplete
      end

      # Format an ability for easy display in the template
      def format_ability(ability, options_set, is_set, remaining_choices)
        {
          name: ability["Name"],
          description: ability["Flavor Text"] || "No description available",
          sklist: ability["SkList"],
          selected_options: options_set,
          is_set: is_set,
          expertise_limit: ability["Expertise"] ? ability["Expertise"].split('/').first.to_i : 0,
          remaining_choices: remaining_choices,
          tier: ability["Tier"] || 'Unknown'
        }
      end

      # Fetch selected options for an ability (if any)
      def fetch_selected_options(ability_name_downcase)
        ability_data = @enactor.rr_specialabilities.find { |sa| sa.name.downcase == ability_name_downcase }
        ability_data&.sklist&.split(',')&.map(&:strip) || []
      end
    end
  end
end