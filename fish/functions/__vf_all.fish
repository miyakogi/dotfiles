function __vf_all --description "Run a command in all virtualenvs sequentially"
    if test (count $argv) -lt 1
        echo "You need to supply a command."
        return 1
    end

    if set -q VIRTUAL_ENV
        set -l old_env (basename $VIRTUAL_ENV)
    end

    for env in (vf ls)
        echo (set_color blue)$env(set_color normal) ➤ Running: (set_color green)$argv(set_color normal) …
        vf activate $env
        eval $argv
    end

    if set -q old_env
        vf activate $old_env
    else
        vf deactivate
    end
end
