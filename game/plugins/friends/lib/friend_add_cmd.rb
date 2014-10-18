module AresMUSH
  module Friends
    class FriendAddCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'friends'
        super
      end
                  
      def want_command?(client, cmd)
        cmd.root_is?("friend") && cmd.switch_is?("add")
      end
      
      def crack!
        self.name = titleize_input(cmd.args)
      end
      
      def handle
        if (self.name.start_with?("@"))
          if (client.char.handle_friends.include?(self.name))
            client.emit_failure t('friends.already_friend', :name => self.name)
            return
          end
          
          client.char.handle_friends << self.name
          client.char.save!
          client.emit_success t('friends.friend_added', :name => self.name)
          return
        end
        
        ClassTargetFinder.with_a_character(self.name, client) do |friend|
          if (client.char.friends.include?(friend))
            client.emit_failure t('friends.already_friend', :name => self.name)
            return
          end

          friendship = Friendship.new(:character => client.char, :friend => friend)
          friendship.save!
          client.emit_success t('friends.friend_added', :name => self.name)
        end
      end
    end
  end
end
