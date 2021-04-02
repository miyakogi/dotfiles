function vf --description "VirtualFish: fish plugin to manage virtualenvs"
    # check for virtualfish installation
    if not test -f /usr/lib/python3.9/site-packages/virtualfish/virtual.fish
        echo "vf command needs virtualfish to be installed."
        echo "Install it by bellow command:"
        echo "yay -S virtualfish"
        return 1
    end

    # Check for existence of $VIRTUALFISH_HOME
    if not test -d $VIRTUALFISH_HOME
        echo "The directory $VIRTUALFISH_HOME does not exist."
        echo "Would you like to create it?"
        echo "Tip: To use a different directory, set the variable \$VIRTUALFISH_HOME."
        read -n1 -p "echo 'y/n> '" -l do_create
        if test $do_create = "y"
            mkdir $VIRTUALFISH_HOME
        else
            return 1
        end
    end

    # copy all but the first argument to $scargs
    set -l sc $argv[1]
    set -l funcname "__vf_$sc"
    set -l scargs

    if begin; [ (count $argv) -eq 0 ]; or [ $sc = "--help" ]; or [ $sc = "-h" ]; end
        # If called without arguments, print usage
        vf help
        return
    end

    if test (count $argv) -gt 1
        set scargs $argv[2..-1]
    end

    if functions -q $funcname
        eval $funcname $scargs
    else
        echo "The subcommand $sc is not defined"
    end
end
