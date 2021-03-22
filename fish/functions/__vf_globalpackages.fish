function __vf_globalpackages --description "Manage global site packages"
    argparse --stop-nonopt --ignore-unknown --name "vf globalpackages" "h/help" -- $argv
    if set -q _flag_help
	    set -l normal (set_color normal)
	    set -l green (set_color green)
	    echo
	    echo "Manage global site packages."
	    echo
	    echo "Usage: "$green"vf globalpackages [<action>] [--quiet/-q]"$normal
	    echo
	    echo "Available actions: "$green"enable"$normal", "$green"disable"$normal", "$green"toggle"$normal" (default)"
	    return 0
    end

    if set -q VIRTUAL_ENV
	    set -l action $argv[1]
	    set -l action_args

	    if begin; test (count $argv) -eq 0; or string match -qr '^\-' -- $argv[1]; end
	        # no action passed, default to toggle
	        set action "toggle"
	        set action_args $argv[1..-1]
	    else
	        set action_args $argv[2..-1]
	    end

	    set -l funcname "__vfsupport_globalpackages_$action"

	    if functions -q $funcname
	        eval $funcname $action_args
	    else
	        echo "Invalid action: $action."
	        return 1
	    end
    else
	    echo "No active virtual environment."
	    return 1
    end
end
