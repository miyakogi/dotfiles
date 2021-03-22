function __vfsupport_check_python --description "Ensure Python/Pip are in a working state"
    argparse "p/pip" -- $argv
    set -l python_path $argv[1]
    set -l pipflag ""
    if set -q _flag_pip
        set pipflag "-m pip"
    end
    set -l test_py (fish -c "'$python_path' $pipflag -V" 2>/dev/null)
    if test $status -ne 0
        return 1
    else
        return 0
    end
end
