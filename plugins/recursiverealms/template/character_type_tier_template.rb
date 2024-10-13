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
        
        # Group items into rows of 3
        def group_items(items, group_size = 3)
          items.each_slice(group_size).to_a
        end   

        # Method to build output strings for the attributes
        def build_attribute_strings(attribute_value)
          outputstring = ""
          flavortext = ""
  
          attribute_value.each do |item|
            if item.is_a?(Hash) # Ensure we're working with a hash
              item.each do |key, val|
                if key != "Flavor Text"
                  # Apply the left formatting for key-value pairs
                  outputstring += left("%xh%xb#{key}:%xn #{val}", 30)
                else
                  # Handle flavor text separately
                  flavortext = "%xh%xb#{key}:%xn #{val}"
                end
              end
              outputstring += "\n"
              outputstring += "      "
            end
          end
          outputstring += flavourtext
          return outputstring.strip, flavortext.strip  # Return the strings without trailing spaces
        end

      end
    end
  end