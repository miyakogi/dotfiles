function __vf_new --description "Create a new virtualenv"
    set -l virtualenv_args
    set -l envname

    # Deactivate the current virtualenv, if one is active
    if set -q VIRTUAL_ENV
        vf deactivate
    end

    emit virtualenv_will_create
    argparse -n "vf new" -x q,v,d --ignore-unknown "h/help" "q/quiet" "v/verbose" "d/debug" "p/python=" "c/connect" "V-version" -- $argv

    if set -q _flag_help
        set -l normal (set_color normal)
        set -l green (set_color green)
        echo "Purpose: Creates a new virtual environment"
        echo "Usage: "$green"vf new "(set_color -di)"[-p <python-version>] [--connect] [-q | -v | -d] [-h] [<virtualenv-flags>]"$normal$green" <virtualenv-name>"$normal
        echo
        echo "Examples:"
        echo
        echo $green"vf new -p /usr/local/bin/python3 yourproject"$normal
        echo $green"vf new -p python3.8 --system-site-packages yourproject"$normal
        echo
        echo "To see available "(set_color blue)"Virtualenv"$normal" option flags, run: "$green"virtualenv --help"$normal
        return 0
    end

    if set -q _flag_version
        eval $VIRTUALFISH_PYTHON_EXEC -m virtualenv --version
        return 0
    end

    # Unpack Virtualenv args: first flags that need values, then Boolean flags
    set -l flags_with_args --app-data --discovery --creator --seeder --activators --extra-search-dir --pip --setuptools --wheel --prompt
    while set -q argv[1]
        # If arg starts with a hyphen…
        if string match -q -- "-*" $argv[1]
            # If this option requires a value that we expect to come after it…
            if contains -- $argv[1] $flags_with_args
                # Move both the option flag and its value to a separate list
                set virtualenv_args $virtualenv_args $argv[1] $argv[2]
                set -e argv[2]
            else
                # This option is a Boolean w/o a value. Move to separate list.
                set virtualenv_args $virtualenv_args $argv[1]
            end
        else
            # No hyphen, so this is (hopefully) the new environment's name
            set envname $argv[1]
        end
        set -e argv[1]
    end

    # Ensure a single non-option-flag argument (environment name) was provided
    if test (count $envname) -lt 1
        echo "No virtual environment name was provided."
        return 1
    else if test (count $envname) -gt 1
        echo (set_color red)"Too many arguments. Except for option flags, only virtual environment name is expected:"(set_color normal)
        echo "Virtualenv args: $virtualenv_args"
        echo "Other args: $envname"
        echo
        vf new --help
        return 1
    end

    # Use Python interpreter if provided; otherwise fall back to sane default
    if set -q _flag_python
        set python (__vfsupport_find_python $_flag_python)
    else
        set python (__vfsupport_get_default_python)
    end

    if set -q python
        set virtualenv_args "--python" $python $virtualenv_args
    end

    # Virtualenv outputs too much, so we use its quiet mode by default.
    # "--verbose" yields its normal output; "--debug" yields its verbose output
    if not set -q _flag_quiet
        # Replace $HOME, if present in Python path, with "~"
        set -l realhome ~
        set -l python_path (string replace -r '^'"$realhome"'($|/)' '~$1' $python)
        echo "Creating "(set_color blue)"$envname"(set_color normal)" via "(set_color green)"$python_path"(set_color normal)" …"
    end
    if set -q _flag_debug
        echo "Virtualenv args: $virtualenv_args"
        echo "Other args: $envname"
        echo "Invoking: $VIRTUALFISH_PYTHON_EXEC -m virtualenv $VIRTUALFISH_HOME/$envname $virtualenv_args"
        set virtualenv_args "--verbose" $virtualenv_args
    else if set -q _flag_verbose
        set virtualenv_args $virtualenv_args
    else
        set virtualenv_args "--quiet" $virtualenv_args
    end

    # Use Virtualenv to create the new environment
    set -lx PIP_USER 0
    eval $VIRTUALFISH_PYTHON_EXEC -m virtualenv $VIRTUALFISH_HOME/$envname $virtualenv_args
    set vestatus $status
    if begin; [ $vestatus -eq 0 ]; and [ -d $VIRTUALFISH_HOME/$envname ]; end
        vf activate $envname
        emit virtualenv_did_create
        emit virtualenv_did_create:(basename $VIRTUAL_ENV)
        if set -q _flag_connect
            vf connect
        end
    else
        echo "Error: The virtual environment was not created properly."
        echo "Virtualenv returned status $vestatus."
        return 1
    end
end
