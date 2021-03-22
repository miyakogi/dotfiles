function __vf_rm --description "Delete one or more virtual environments"
    if [ (count $argv) -lt 1 ]
        echo "You need to specify at least one virtual environment."
        return 1
    end
    for venv in $argv
        if begin; set -q VIRTUAL_ENV; and [ $venv = (basename $VIRTUAL_ENV) ]; end
            echo "The environment \"$venv\" is active and thus cannot be deleted."
            return 1
        end
        echo "Removing $VIRTUALFISH_HOME/$venv"
        emit virtualenv_will_remove
        emit virtualenv_will_remove:$venv
        if command -q trash
            command trash $VIRTUALFISH_HOME/$venv
        else
            command rm -rf $VIRTUALFISH_HOME/$venv
        end
        emit virtualenv_did_remove
        emit virtualenv_did_remove:$venv
    end
end
