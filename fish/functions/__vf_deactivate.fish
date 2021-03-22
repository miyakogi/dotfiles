function __vf_deactivate --description "Deactivate this virtualenv"

    if not set -q VIRTUAL_ENV
        echo "No virtualenv is activated."
        return
    end

    emit virtualenv_will_deactivate
    emit virtualenv_will_deactivate:(basename $VIRTUAL_ENV)

    # find elements to remove from PATH
    set to_remove
    for i in (seq (count $PATH))
        if contains -- $PATH[$i] $_VF_EXTRA_PATH
            set to_remove $to_remove $i
        end
    end

    # remove them
    for i in $to_remove
        set -e PATH[$i]
    end

    # restore PYTHONHOME, PIP_USER
    if set -q _VF_OLD_PYTHONHOME
        set -gx PYTHONHOME $_VF_OLD_PYTHONHOME
        set -e _VF_OLD_PYTHONHOME
    end
    if set -q _VF_OLD_PIP_USER
        set -gx PIP_USER $_VF_OLD_PIP_USER
        set -e _VF_OLD_PIP_USER
    end

    emit virtualenv_did_deactivate
    emit virtualenv_did_deactivate:(basename $VIRTUAL_ENV)

    set -e VIRTUAL_ENV
end
