module AresMUSH
    module RecursiveRealms

        #This is a sample helper function for testing
        def self.greet(name)
            "Hello, #{name}!"
        end

        def self.wrap_text(text, line_width = 80)
            text.scan(/.{1,#{line_width}}(?:\s+|$)|\S+/).each do |line|
            puts line.strip
          end
        end
    end
end
  