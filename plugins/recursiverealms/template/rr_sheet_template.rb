module AresMUSH
  module RecursiveRealms
    class RRSheetTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          super File.dirname(__FILE__) + "/rr_sheet.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end