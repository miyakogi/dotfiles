function __vf_activate --description "Activate a virtualenv"
    # check arguments
    if [ (count $argv) -lt 1 ]
        echo "You need to specify a virtualenv."
        return 1
    end
    if not [ -d $VIRTUALFISH_HOME/$argv[1] ]
        echo "The virtualenv $argv[1] does not exist."
        echo "You can create it with mkvirtualenv."
        return 2
    end

    #Check if a different env is being used
    if set -q VIRTUAL_ENV
        vf deactivate
    end

    # Set VIRTUAL_ENV before the others so that the will_activate event knows
    # which virtualenv is about to be activated
    set -gx VIRTUAL_ENV $VIRTUALFISH_HOME/$argv[1]

    emit virtualenv_will_activate
    emit virtualenv_will_activate:$argv[1]

    set -g _VF_EXTRA_PATH $VIRTUAL_ENV/bin
    set -gx PATH $_VF_EXTRA_PATH $PATH

    # hide PYTHONHOME, PIP_USER
    if set -q PYTHONHOME
        set -g _VF_OLD_PYTHONHOME $PYTHONHOME
        set -e PYTHONHOME
    end
    if set -q PIP_USER
        set -g _VF_OLD_PIP_USER $PIP_USER
        set -e PIP_USER
    end

    # Warn if virtual environment name does not appear in prompt
    if begin; not set -q VIRTUAL_ENV_DISABLE_PROMPT; or test -z "$VIRTUAL_ENV_DISABLE_PROMPT"; end
        if begin; not set -q fish_right_prompt; or not string match -q -- "*$argv[1]*" (eval fish_right_prompt); end
            and not string match -q -- "*$argv[1]*" (eval fish_prompt)
            echo "Virtual environment activated but not shown in shell prompt. To fix, see:"
            echo "<https://virtualfish.readthedocs.io/en/latest/install.html#customizing-your-fish-prompt>"
        end
    end

    emit virtualenv_did_activate
    emit virtualenv_did_activate:(basename $VIRTUAL_ENV)
end
