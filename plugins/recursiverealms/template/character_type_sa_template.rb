module AresMUSH
  module RecursiveRealms
    class CharacterTypeSATemplate < ErbTemplateRenderer
        attr_accessor :chartype, :tier_selection
  
        def initialize(chartype, tierselection)
          @chartype = chartype
          @tier_selection = tier_selection          
          super File.dirname(__FILE__) + "/character_type_sa.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

        def tiers
          # If a specific tier is provided, return only that tier
          if @tier_selection
            return { "Tier #{@tier_selection}" => @chartype['Tiers']["Tier #{@tier_selection}"] }
          else
            # Otherwise, return all tiers
            return @chartype['Tiers']
          end
        end  
      end
    end
  end