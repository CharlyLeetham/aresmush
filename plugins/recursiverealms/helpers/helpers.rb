module AresMUSH
    module RecursiveRealms

        def self.split_command(cmd)
            split_switch = cmd.raw.split('/', 4).reject(&:empty?)    
            arg1 = split_switch.length > 1 ? split_switch[1] : nil
            arg2 = split_switch.length > 2 ? split_switch[2] : nil
            arg3 = split_switch.length > 3 ? split_switch[3] : nil
           return [arg1, arg2, arg3]
        end

        def self.multi_split_command(cmd)
            split_switch = cmd.raw.split('/').reject(&:empty?)
            return split_switch[1..-1] # Return all arguments except the first (which is typically the command root)
        end

        
    end
end
