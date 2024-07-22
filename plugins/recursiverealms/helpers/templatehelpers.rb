module AresMUSH
    module RecursiveRealms
      module TemplateHelpers
        def center_text(text, width)
          padding = (width - text.length) / 2
          ' ' * padding + text + ' ' * padding
        end
      end
    end
  end
  