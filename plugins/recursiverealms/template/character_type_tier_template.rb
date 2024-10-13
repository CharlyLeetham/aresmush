module AresMUSH
  module RecursiveRealms
    class CharacterTypeTierTemplate < ErbTemplateRenderer
        attr_accessor :chartype, :tiers
  
        def initialize(chartype, tiers)
          @chartype = chartype
          @tiers = tiers
          super File.dirname(__FILE__) + "/character_type_tier.erb"
        end

        def chartypetitle
          return @chartype["Type"]
        end

        def tiers
          # If a specific tier is provided, return only that tier
          if @tier
            return { "Tier #{@tier}" => @chartype['Tiers']["Tier #{@tier}"] }
          else
            # Otherwise, return all tiers
            return @chartype['Tiers']
          end
        end        

      end
    end
  end