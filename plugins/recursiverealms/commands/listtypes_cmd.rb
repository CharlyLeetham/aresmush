module AresMUSH
    module Rr
      class ListTypesCmd
        include CommandHandler
  
        def handle
          types = Global.read_config("rr", "characters").map { |c| c['Type'] }
          client.emit_ooc "Available Character Types: #{types.join(", ")}"
        end
      end
    end
  end