module AresMUSH
  module RecursiveRealms
    class CharacterTypeTemplate
      attr_accessor :character

      def initialize(character)
        @character = character
      end

      def render
        name_header = "|#{' ' * ((165 - 'Type:'.length) / 2)}\e[1mType:\e[0m#{' ' * ((165 - 'Type:'.length) / 2)}|"
        description_header = "\e[1mDescription:\e[0m"
        attributes_header = "\e[1mMight\e[0m: #{character['Might']}   \e[1mSpeed\e[0m: #{character['Speed']}   \e[1mIntellect\e[0m: #{character['Intellect']}   \e[1mAdditional Points\e[0m: #{character['Additional Points']}"

        <<-INFO
#{name_header}
#{character['Type']}
#{description_header}
#{character['Descriptor']}
#{attributes_header}
        INFO
      end
    end
  end
end
