module AresMUSH
  module RecursiveRealms
    class FocusDetailTemplate < ErbTemplateRenderer
        attr_accessor :focus
  
        def initialize(focus)
          @focus = focus
          super File.dirname(__FILE__) + "/focus_detail.erb"
        end

        def chartypetitle
          return @focus["Focus"]
        end

      end
    end
  end