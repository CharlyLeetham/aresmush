module AresMUSH
    module RecursiveRealms

        def self.split_command(cmd)
            split_switch = cmd.switch.split('/').reject(&:empty?)
            arg1 = split_switch[0]
            arg2 = split_switch.length > 1 ? split_switch[1].downcase : nil
            arg3 = split_switch.length > 2 ? split_switch[2].downcase : nil
           return [topcmd, type, value]
        end
    end
end
