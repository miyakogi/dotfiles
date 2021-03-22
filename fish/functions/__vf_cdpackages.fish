function __vf_cdpackages --description "Change to the site-packages directory of this virtualenv"
    if set -q VIRTUAL_ENV
        cd (find $VIRTUAL_ENV -name site-packages -type d | head -n1)
    else
        echo "No virtualenv is active."
    end
end
