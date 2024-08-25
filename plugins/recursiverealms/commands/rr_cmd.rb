module AresMUSH
    module RecursiveRealms
      class ListTypeCmd 
        include CommandHandler
   
        def handle
            template = RRCommandTemplate.new
            client.emit template.render
        end  
    end
  end
  