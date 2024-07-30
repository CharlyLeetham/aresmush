module AresMUSH
  module RecursiveRealms
    class ListTypeCmd 
      include CommandHandler

      attr_accessor :detail
          
      def handle
        @client.emit_failure "#{detail}"
        #chartype = Global.read_config("RecursiveRealms", "characters").find { |c| c['Type'].downcase == @detail }
        #if chartype
        #      template = CharacterTypeTemplate.new(chartype)
        #      client.emit template.render
        #else
        #  @client.emit_failure "Character type not found."
        #end
      end     
    end
  end
end
