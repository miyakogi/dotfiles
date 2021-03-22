function __vf_addplugins --description "Install one or more plugins"
    if test (count $argv) -lt 1
        echo "Provide a plugin to add"
        return -1
    end
    set -l python (__vfsupport_get_default_python --exec)
    $python -m virtualfish.loader.installer addplugins $argv
end
