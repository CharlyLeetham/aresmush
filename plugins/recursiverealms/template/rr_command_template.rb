module AresMUSH
  module RecursiveRealms
    class RRCommandTemplate < ErbTemplateRenderer
  
        def initialize()
          super File.dirname(__FILE__) + "/rr_command.erb"
        end

      end
    end
  end