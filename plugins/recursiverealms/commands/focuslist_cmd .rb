module AresMUSH
  module RecursiveRealms
    class FocusListCmd
      include CommandHandler

      def handle
        focus_config = Global.read_config("RecursiveRealms", "focuses")
        
        if focus_config.nil?
          client.emit_ooc "Error: Configuration data not found. Please check the rr_focus.yml file."
          return
        end

        begin
          focus_config.each do |focus|
            template = FocusListTemplate.new(focus)
            client.emit template.render
          end
        rescue => e
          client.emit_ooc "Error: #{e.message}"
          Global.logger.error "Error reading focus types: #{e.message}"
        end
      end
    end
  end
end
