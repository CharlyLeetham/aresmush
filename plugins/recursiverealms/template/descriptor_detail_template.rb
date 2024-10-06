module AresMUSH
  module RecursiveRealms
    class DescriptorDetailTemplate < ErbTemplateRenderer
        attr_accessor :descriptor
  
        def initialize(descriptor)
          @descriptor = descriptor
          super File.dirname(__FILE__) + "/descriptor_detail.erb"
        end

        def descriptordetailtitle
          return @descriptor["Descriptor"]
        end

      end
    end
  end