function __vf_connect --description "Connect this virtualenv to the current directory"
    if set -q VIRTUAL_ENV
        basename $VIRTUAL_ENV > $VIRTUALFISH_ACTIVATION_FILE
        emit virtualenv_did_connect
        emit virtualenv_did_connect:(basename $VIRTUAL_ENV)
    else
        echo "No virtualenv is active."
    end
end
