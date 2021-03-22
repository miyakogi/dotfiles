function __vf_uninstall --description "Uninstall VirtualFish"
    set -l python (__vfsupport_get_default_python --exec)
    $python -m virtualfish.loader.installer uninstall
    echo "VirtualFish has been uninstalled from this shell."
    echo "Run 'exec fish' to reload Fish."
    echo "Note that the Python package will still be installed and needs to be removed separately (e.g. using 'pip uninstall virtualfish')."
end
