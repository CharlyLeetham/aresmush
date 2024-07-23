module AresMUSH
    module self.RecursiveRealms
        def center_text(text, width)
          padding = (width - text.length) / 2
          ' ' * padding + text + ' ' * padding
        end
    end
end
  