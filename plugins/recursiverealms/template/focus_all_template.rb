module AresMUSH
    module RecursiveRealms
      class FocusListTemplate < ErbTemplateRenderer
        attr_accessor :focus
  
        def initialize(focus)
          @focus = focus
          super File.dirname(__FILE__) + "/focus_all.erb"
        end

        def focustitle
          return @focus["Focus"]
        end

      end
    end
  end
  