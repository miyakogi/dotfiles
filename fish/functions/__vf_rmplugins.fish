function __vf_rmplugins --description "Remove one or more plugins"
    if test (count $argv) -lt 1
        echo "Provide a plugin to remove"
        return -1
    end
    set -l python (__vfsupport_get_default_python --exec)
    $python -m virtualfish.loader.installer rmplugins $argv
end
