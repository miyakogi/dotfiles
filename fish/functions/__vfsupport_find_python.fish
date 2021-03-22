function __vfsupport_find_python --description "Search for and return Python path"
    set -l python
    set -l python_arg $argv[1]
    set -l py_version (string replace "python" "" $python_arg)
    set -l brew_path "/usr/local/opt/python@$py_version/bin/python$py_version"
    # Executable on PATH (python3/python3.8) or full interpreter path
    if set -l py_path (command -s $python_arg)
        set python "$py_path"
    # Use `asdf` Python plugin, if found and provided version is available
    else if type -q "asdf"
        set -l asdf_plugins (asdf plugin list)
        if contains python $asdf_plugins
            set -l asdf_path (asdf where python $py_version)/bin/python
            if command -q "$asdf_path"
                set python "$asdf_path"
            end
        end
    # Use Pyenv, if found and provided version is available
    else if type -q "pyenv"
        set -l pyenv_path (pyenv which python$py_version)
        if command -q "$pyenv_path"
            set python "$pyenv_path"
        end
    # Use Pythonz, if found and provided version is available
    else if type -q "pythonz"
        set -l pythonz_path (pythonz locate $py_version)
        if command -q "$pythonz_path"
            set python "$pythonz_path"
        end
    # Version number in Homebrew keg-only versioned Python formula
    else if command -q "$brew_path"
        set python "$brew_path"
    end
    # If no interpreter was found, pass to Virtualenv as-is
    if begin; not command -q "$python"; or not __vfsupport_check_python "$python"; end
        set python $python_arg
    end
    echo $python
end
