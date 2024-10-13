module AresMUSH
    module RecursiveRealms
      class CharacterTypesTemplate < ErbTemplateRenderer
        attr_accessor :chartype
  
        def initialize(chartype)
          @chartype = chartype
          puts "Chartype: #{@chartype}"
          super File.dirname(__FILE__) + "/character_types.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

      end
    end
  end
  