function __vf_connect --description "Connect this virtualenv to the current directory"
    set -l normal (set_color normal)
    set -l green (set_color green)
    set -l red (set_color red)

    if test (count $argv) -gt 1
        echo "Usage: "$green"vf connect [<envname>]"$normal
        return 1
    end

    test (count $argv) -eq 0; or vf activate $argv[1]

    if set -q VIRTUAL_ENV
        basename $VIRTUAL_ENV > $VIRTUALFISH_ACTIVATION_FILE
        emit virtualenv_did_connect
        emit virtualenv_did_connect:(basename $VIRTUAL_ENV)
    else
        echo $red"Cannot connect without an active virtual environment."$normal
        return 1
    end
end
