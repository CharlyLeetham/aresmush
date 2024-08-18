module AresMUSH
    module RecursiveRealms

        #This is a sample helper function for testing
        def self.greet(name)
            "Hello, #{name}!"
        end


        def rr_wrap_text(str, target_width)
            return "" if str.nil? || str.empty?
          
            words = str.split(/\s+/)
            lines = []
            current_line = ""
          
            words.each do |word|
              if (current_line + word).length <= target_width
                current_line += word + " "
              else
                lines << current_line.rstrip
                current_line = word + " "
              end
            end
          
            lines << current_line.rstrip unless current_line.empty?
            lines.join("\n")
        end
          
        # Use the wrap_text function and then apply SubstitutionFormatter.left
        def rr_format_text(str, target_width, pad_char = " ")
            wrapped_text = rr_wrap_text(str, target_width)
            wrapped_lines = wrapped_text.split("\n")
          
            wrapped_lines.map do |line|
              SubstitutionFormatter.left(line, target_width, pad_char)
            end.join("\n")
        end
    end
end
  