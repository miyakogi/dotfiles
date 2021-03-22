function __vfsupport_globalpackages_disable --description "Disable global site packages"
    argparse -n "vf globalpackages disable" "q/quiet" -- $argv
    pushd $VIRTUAL_ENV
    if test -e $VIRTUALFISH_VENV_CONFIG_FILE  # PEP 405
	    command sed -i '/include-system-site-packages/ s/\(true\|false\)/false/' $VIRTUALFISH_VENV_CONFIG_FILE
    else  # legacy
	    # use site-packages/.. to avoid ending up in python-wheels
	    pushd $VIRTUAL_ENV/lib/python*/site-packages/..
	    command rm -f $VIRTUALFISH_GLOBAL_SITE_PACKAGES_FILE
	    popd
    end
    popd

    if not set -q _flag_quiet
	    echo "Global site packages disabled."
    end
end
