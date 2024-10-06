module AresMUSH
    module RecursiveRealms
      class DescriptorListTemplate < ErbTemplateRenderer
        attr_accessor :descriptor
  
        def initialize(descriptor)
          @descriptor = descriptor
          super File.dirname(__FILE__) + "/descriptor_all.erb"
        end

        def descriptortitle
          return @descriptor["Descriptor"]
        end

      end
    end
  end
  