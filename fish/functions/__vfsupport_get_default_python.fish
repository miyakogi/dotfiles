function __vfsupport_get_default_python --description "Return Python interpreter defined in variables, if any"
    argparse "e/exec" -- $argv
    # Prefer VIRTUALFISH_DEFAULT_PYTHON unless --exec is passed
    if begin; not set -q _flag_exec; and set -q VIRTUALFISH_DEFAULT_PYTHON; end
        echo $VIRTUALFISH_DEFAULT_PYTHON
    else if set -q VIRTUALFISH_PYTHON_EXEC
        echo $VIRTUALFISH_PYTHON_EXEC
    else if set -q VIRTUALFISH_DEFAULT_PYTHON
        echo $VIRTUALFISH_DEFAULT_PYTHON
    else
        echo python
    end
end
