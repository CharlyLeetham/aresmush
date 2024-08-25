module AresMUSH
  module RecursiveRealms
    class FocusDetailTemplate < ErbTemplateRenderer
        attr_accessor :focus
  
        def initialize(focus)
          @focus = focus
          super File.dirname(__FILE__) + "/focus_detail.erb"
        end

        def focusdetailtitle
          return @focus["Focus"]
        end

      end
    end
  end