function __vf_cd --description "Change directory to this virtualenv"
    if set -q VIRTUAL_ENV
        cd $VIRTUAL_ENV
    else
        echo "Cannot locate an active virtualenv."
    end
end
