module AresMUSH
    module RecursiveRealms

        def self.split_command(cmd)
            split_switch = cmd.switch.split('/', 3).reject(&:empty?)
            arg1 = split_switch[0]
            arg2 = split_switch.length > 1 ? split_switch[1..-1].join('/').downcase : nil
            arg3 = split_switch.length > 2 ? split_switch[2].downcase : nil
           return [arg1, arg2, arg3]
        end
    end
end
