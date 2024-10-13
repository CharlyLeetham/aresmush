module AresMUSH
  module RecursiveRealms
    class CharacterTypeTierTemplate < ErbTemplateRenderer
        attr_accessor :chartype, :tier_selection
  
        def initialize(chartype, tier_selection = nil)
          @chartype = chartype
          @tier_selection = tier_selection
          super File.dirname(__FILE__) + "/character_type_tier.erb"
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
        
        # Group any array-type attributes into rows of 3
        def group_items(items, group_size = 3)
          items.each_slice(group_size).to_a
        end        

      end
    end
  end