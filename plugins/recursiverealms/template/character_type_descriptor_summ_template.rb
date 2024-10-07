module AresMUSH
  module RecursiveRealms
    class CharacterTypeDescriptorSummTemplate < ErbTemplateRenderer
      attr_accessor :chartype, :descriptors

      def initialize(enactor, chartype, descriptors)
        @enactor = enactor
        @chartype = chartype
        @descriptors = descriptors
        @selected_descriptor = enactor.rr_traits.first&.descriptor&.downcase             
        super File.dirname(__FILE__) + "/character_type_descriptor_summ.erb"
      end

      def chartypetitle
        @chartype["Type"]
      end

      def descriptor_list
        @descriptors.map do |descriptor|
          {
            name: descriptor["Descriptor"],
            description: descriptor["Flavor Text"] || "No description available",
            selected: descriptor["ID"] == @selected_descriptor
          }
        end
      end
    end
  end
end