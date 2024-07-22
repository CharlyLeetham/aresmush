module AresMUSH
    module RecursiveRealms
      class ListTypesCmd
        include CommandHandler
  
        def handle
          types = Global.read_config("RecursiveRealms", "characters").map { |c| c['Type'] }
          client.emit_ooc "Available Character Types: #{types.join(", ")}"
        end
      end
    end
  end