module AresMUSH
  module Sheet
    class SheetPage1Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def name
        left(@char.name, 25)
      end
      
      def page_title
        right(t('sheet.page1_title'), 53)
      end
      
      def fullname_title
        format_field_title(t('sheet.fullname_title'))
      end

      def gender_title
        format_field_title(t('sheet.gender_title'))
      end

      def height_title
        format_field_title(t('sheet.height_title'))
      end

      def build_title
        format_field_title(t('sheet.build_title'))
      end

      def hair_title
        format_field_title(t('sheet.hair_title'))
      end

      def eyes_title
        format_field_title(t('sheet.eyes_title'))
      end

      def age_title
        format_field_title(t('sheet.age_title'))
      end

      def birthdate_title
        format_field_title(t('sheet.birthdate_title'))
      end
      
      def reputation_title
        "%xh#{t('sheet.reputation_title')}%xn #{t('sheet.reputation_subtitle')}"
      end
      
      def format_field_title(title)
        "%xh#{left(title, 12)}%xn"
      end
      
      def format_field(field)
        left("#{field}", 25)
      end
      
      def fullname
        format_field @char.fullname
      end
      
      def gender
        format_field @char.gender
      end
      
      def height
        format_field @char.height
      end
      
      def build
        format_field @char.build
      end
      
      def hair
        format_field @char.hair
      end
      
      def eyes
        format_field @char.eyes
      end
      
      def age
        format_field @char.age
      end
      
      def birthdate
        format_field @char.birthdate.nil? ? "" : @char.birthdate
      end
      
      def reputation
        @char.reputation
      end
    end
  end
end