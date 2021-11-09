function __vf_ls --description "List all available virtual environments"
    argparse -n "vf ls" "h/help" "d/details" -- $argv
    set -l normal (set_color normal)
    set -l green (set_color green)
    set -l red (set_color red)
    if set -q _flag_help
        echo
        echo "Purpose: List existing virtual environments"
        echo "Usage: "$green"vf ls "(set_color -di)"[--details]"$normal
        echo
        echo "Add "$green"--details"$normal" to see per-environment Python version numbers"\n
        return 0
    end
    begin; pushd $VIRTUALFISH_HOME; and set -e dirprev[-1]; end
    # If passed --details, determine default Python version number
    set -l default_python_version
    if set -q _flag_details
        set -l default_python (__vfsupport_get_default_python)
        __vfsupport_check_python $default_python
        if test $status -eq 0
            set default_python_version ($default_python -V | string split " ")[2]
        else
            echo "Could not determine default Python. Add interpreter to Fish config via something like:"
            echo $green\n"set -g VIRTUALFISH_DEFAULT_PYTHON /path/to/valid/bin/python"$normal\n
            return -1
        end
    end
    # Iterate over environments, showing colored version numbers if passed --details
    for p in */bin/python
        if set -q _flag_details
            set -l env_python_version
            # Check whether environment's Python is busted
            __vfsupport_check_python --pip "$VIRTUALFISH_HOME/$p"
            if test $status -eq 0
                set env_python_version ("$VIRTUALFISH_HOME/$p" -V | string split " ")[2]
                # If ASDF tool version list is available, retrieve specified Python versions
                if test -e ~/.tool-versions
                    set python_versions (cat ~/.tool-versions | grep python | sed "s|python ||")
                end
                # If preferred Python versions are specified in ASDF tool version list,
                # display in green if current env's Python matches one of those versions (else yellow).
                if test -n "$python_versions"
                    if string match --entire --quiet "$env_python_version" "$python_versions"
                        set env_python_version $green$env_python_version$normal
                    else
                        set env_python_version (set_color yellow)$env_python_version$normal
                    end
                # Otherwise, infer default Python version and compare to that
                else
                    __vfsupport_compare_py_versions $env_python_version $default_python_version
                    if test $status -eq 1
                        set env_python_version (set_color yellow)$env_python_version$normal
                    else
                        set env_python_version $green$env_python_version$normal
                    end
                end
            else
                set env_python_version $red"broken"$normal
            end
            printf "%-33s %s\n" $p $env_python_version
        else
            # No --details flag, so just print the virtual environment names
            echo $p
        end
    end | sed "s|/bin/python||"
    begin; popd; and set -e dirprev[-1]; end
end
