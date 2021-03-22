function __vfsupport_globalpackages_toggle --description "Toggle global site packages"
    pushd $VIRTUAL_ENV
    set -l globalpkgs_enabled
    if test -e $VIRTUALFISH_VENV_CONFIG_FILE  # PEP 405
	    if [ "true" = (command sed -n 's/include-system-site-packages\s=\s\(true\|false\)/\1/p' $VIRTUALFISH_VENV_CONFIG_FILE) ]
	        set globalpkgs_enabled 0
	    else
	        set globalpkgs_enabled 1
	    end
    else  # legacy
	    # use site-packages/.. to avoid ending up in python-wheels
	    pushd $VIRTUAL_ENV/lib/python*/site-packages/..
	    if test -e $VIRTUALFISH_GLOBAL_SITE_PACKAGES_FILE
	        set globalpkgs_enabled 0
	    else
	        set globalpkgs_enabled 1
	    end
	    popd
    end
    popd

    if test $globalpkgs_enabled -eq 0
	    __vfsupport_globalpackages_disable $argv
    else
	    __vfsupport_globalpackages_enable $argv
    end
end
