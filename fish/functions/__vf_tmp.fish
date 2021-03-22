function __vf_tmp --description "Create a virtualenv that will be removed when deactivated"
    set -l env_name (printf "%s%.4x" "tempenv-" (random) (random) (random))
    vf new $argv $env_name
    and set -g _VF_TEMPORARY_ENV $env_name
end
