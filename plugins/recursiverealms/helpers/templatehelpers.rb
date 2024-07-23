module AresMUSH
    module RecursiveRealms

        def self.center_text(text, width)
          padding = (width - text.length) / 2
          ' ' * padding + text + ' ' * padding
        end

        def self.greet(name)
            "Hello, #{name}!"
        end
    end
end
  