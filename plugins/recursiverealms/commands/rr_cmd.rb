module AresMUSH
    module RecursiveRealms
      class RRCmd 
        include CommandHandler
        def handle
            template = RRCommandTemplate.new
            client.emit template.render
        end  
       end
    end
  end
  