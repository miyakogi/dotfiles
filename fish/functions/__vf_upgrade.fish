function __vf_upgrade --description "Upgrade virtualenv(s) to newer Python version"
    argparse -n "vf upgrade" "h/help" "p/python=" "r/rebuild" "a/all" -- $argv
    set -l python
    set -l venv_list
    set -l normal (set_color normal)
    set -l green (set_color green)

    if set -q _flag_help
        echo
        echo "Purpose: Upgrades existing virtual environment(s)"
        echo "Usage: "$green"vf upgrade "(set_color -di)"[--rebuild] [--python <path/version>] [--all] <env name(s)>"$normal
        echo
        echo "Examples:"
        echo
        echo (set_color -di)"# Upgrade active virtual environment to current default Python version"$normal
        echo $green"vf upgrade"$normal
        echo (set_color -di)"# Rebuild env1 & env2 using Python 3.8.5 via asdf, pyenv, or Pythonz"$normal
        echo $green"vf upgrade --rebuild --python 3.8.5 env1 env2"$normal\n
        return 0
    end

    # Use Python interpreter if provided; otherwise fall back to sane default
    if set -q _flag_python
        set python (__vfsupport_find_python $_flag_python)
    else
        set python (__vfsupport_get_default_python)
    end
    __vfsupport_check_python $python
    if test $status -ne 0
        echo "Specified (or default) Python interpreter does appear to be valid."
        return -1
    end
    # Set envs to upgrade: all, a list of virtualenvs, or current environment
    if set -q _flag_all
        set venv_list (vf ls)
    else if test (count $argv) -gt 0
        set venv_list $argv
    else if set -q VIRTUAL_ENV
        set venv_list (basename $VIRTUAL_ENV)
    else
        echo "No environment activated or specified."
        return 1
    end
    for venv in $venv_list
        set -l packages
        set -l venv_path "$VIRTUALFISH_HOME/$venv"

        emit virtualenv_will_upgrade
        emit virtualenv_will_upgrade:$venv

        __vfsupport_check_python --pip "$venv_path/bin/python"
        if test $status -ne 0
            echo (set_color red)"$venv is broken. Rebuilding…"(set_color normal)
            for p in $venv_path/lib/python3.*/site-packages/*.dist-info
                set packages $packages (string replace "-" "==" (string replace ".dist-info" "" (basename $p)))
            end
        end
        # Re-build if (1) --rebuild passed or (2) above check yields broken env
        if begin; set -q _flag_rebuild; or test -n "$packages"; end
            set -l install_cmd
            # Install via poetry.lock if found; otherwise Pip-install packages
            if begin; set -q PROJECT_HOME; and test -f "$PROJECT_HOME/$venv/poetry.lock"; end
                set install_cmd "poetry install"
            else
                # If broken env, use above package list. Otherwise use `pip freeze`.
                if test -z "$packages"
                    set packages ($venv_path/bin/pip freeze)
                end
                set install_cmd "if test -n '$packages'; pip install -U $packages; end"
            end
            if set -q VIRTUAL_ENV
                vf deactivate
            end
            # If environment contains a .project file, save its contents before removing
            if test -e $venv_path/.project
                set linked_project (cat $venv_path/.project)
            end
            vf rm $venv
            and vf new -p $python $venv
            and eval $install_cmd
            # If environment contained a .project file, restore its contents
            if set -q project_file_path[1]
                echo $linked_project > $venv_path/.project
            end
        else
            # Minor upgrade, so modify existing env's symlinks & version numbers
            # Get full version numbers for both old and new Python interpreters
            set -l old_py_fv ($venv_path/bin/python -V | string split " ")[2]
            set -l new_py_fv ($python -V | string split " ")[2]
            # Get and compare *major* version numbers (e.g., 3.8, 3.9)
            set -l old_py_sv (string split . $old_py_fv)
            set -l new_py_sv (string split . $new_py_fv)
            set -l old_py_mv "$old_py_sv[1].$old_py_sv[2]"
            set -l new_py_mv "$new_py_sv[1].$new_py_sv[2]"
            # If major version numbers don't match, exit without upgrading
            if test "$old_py_mv" -ne "$new_py_mv"
                echo "Not upgrading $venv ($old_py_fv) to $new_py_fv. Add '--rebuild' for major version upgrades."
            else
                # Update symlinks & version numbers
                echo "Upgrading $venv from $old_py_fv to $new_py_fv"
                if [ -L "$venv_path/bin/python" ]; command rm "$venv_path/bin/python"; end
                command ln -s "$python$new_py_mv" "$venv_path/bin/python"
                if [ -L "$venv_path/bin/python3" ]; command rm "$venv_path/bin/python3"; end
                command ln -s "$python$new_py_mv" "$venv_path/bin/python3"
                if [ -L "$venv_path/bin/python$old_py_mv" ]; command rm "$venv_path/bin/python$old_py_mv"; end
                command ln -s "$python$new_py_mv" "$venv_path/bin/python$new_py_mv"
                if test -f "$venv_path/pyvenv.cfg"
                    command sed -i '' -e "s/$old_py_fv/$new_py_fv/g" "$venv_path/pyvenv.cfg"
                end
                # Clear caches
                command find "$venv_path" -name "__pycache__" -type d -print0|xargs -0 rm -r --
                if begin; set -q PROJECT_HOME; and test -d "$PROJECT_HOME/$venv"; end
                    command find "$PROJECT_HOME/$venv" -name "__pycache__" -type d -print0|xargs -0 rm -r --
                    command find "$PROJECT_HOME/$venv" -name ".pytest_cache" -type d -print0|xargs -0 rm -r --
                end
            end
        end
        emit virtualenv_did_upgrade
        emit virtualenv_did_upgrade:$venv
    end
end
