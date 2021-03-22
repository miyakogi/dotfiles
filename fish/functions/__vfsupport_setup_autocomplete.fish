################
# Autocomplete
# Based on https://github.com/zmalltalker/fish-nuggets/blob/master/completions/git.fish
function __vfsupport_setup_autocomplete --on-event virtualfish_did_setup_plugins
    function __vfcompletion_needs_command
        set cmd (commandline -opc)
            if test (count $cmd) -eq 1 -a $cmd[1] = 'vf'
            return 0
        end
        return 1
    end

    function __vfcompletion_using_command
        set cmd (commandline -opc)
        if test (count $cmd) -gt 1
            if test $argv[1] = $cmd[2]
                return 0
            end
        end
        return 1
    end

    # add completion for subcommands
    for sc in (functions -a | sed -n '/__vf_/{s///g;p;}')
        set -l helptext (functions "__vf_$sc" | grep -m1 "^function" | sed -E "s|.*'(.*)'.*|\1|")
        complete -x -c vf -n '__vfcompletion_needs_command' -a $sc -d $helptext
    end

    complete -x -c vf -n '__vfcompletion_using_command activate' -a "(vf ls)"
    complete -x -c vf -n '__vfcompletion_using_command rm' -a "(vf ls)"
end
