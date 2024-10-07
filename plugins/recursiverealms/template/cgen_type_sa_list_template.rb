module AresMUSH
  module RecursiveRealms
    class SpecialAbilitiesTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :abilities, :current_tier, :expertise_one_abilities, :expertise_two_or_more_abilities

      def initialize(abilities, enactor, traits)
        @enactor = enactor
        @abilities = abilities
        @current_tier = traits.tier || 'Unknown'
        @selected_abilities = enactor.rr_specialabilities.to_a # Store the full objects
        @traits = traits

        super File.dirname(__FILE__) + "/cgen_type_sa_list.erb"

        # Separate abilities into expertise 1 and 2+ for display
        @expertise_one_abilities = format_abilities_by_expertise(1)
        @expertise_two_or_more_abilities = format_abilities_by_expertise(2, true)
      end

      def chartypetitle
        @traits.type.capitalize
      end

      # Format abilities based on their expertise level
      def format_abilities_by_expertise(expertise, higher = false)
        filtered_abilities = @abilities.select do |ability|
          ability_expertise = ability['Expertise'].to_s.split('/').first.to_i
          higher ? ability_expertise >= expertise : ability_expertise == expertise
        end

        filtered_abilities.map do |ability|
          ability_name = ability["Name"]
          ability_name_downcase = ability_name.downcase
          is_set = @selected_abilities.any? { |sa| sa.name.downcase == ability_name_downcase } # Compare the name dynamically
          sklist = ability["SkList"]
          selected_options = fetch_selected_options(ability_name_downcase)
          expertise_limit = ability["Expertise"] ? ability["Expertise"].split('/').first.to_i : 0
          remaining_choices = expertise_limit - selected_options.size

          {
            name: ability_name,
            description: ability["Flavor Text"] || "No description available",
            sklist: sklist,
            selected_options: selected_options,
            is_set: is_set,
            expertise_limit: expertise_limit,
            remaining_choices: remaining_choices,
            tier: ability["Tier"] || 'Unknown'
          }
        end
      end

      # Fetch selected options for the given ability
      def fetch_selected_options(ability_name_downcase)
        ability_data = @selected_abilities.find { |sa| sa.name.downcase == ability_name_downcase }
        ability_data&.sklist&.split(',')&.map(&:strip) || []
      end
    end
  end
end