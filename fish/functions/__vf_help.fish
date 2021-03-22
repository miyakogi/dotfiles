function __vf_help --description "Print VirtualFish usage information"
    echo "VirtualFish $VIRTUALFISH_VERSION"
    echo
    echo "Usage: vf <command> [<args>]"
    echo
    echo "Available commands:"
    echo

    # Dynamically calculate column spacing, based on longest subcommand
    set -l subcommands (functions -a | sed -n '/__vf_/{s///g;p;}')
    set -l max_subcommand_length 0
    for sc in $subcommands
        set -l cur (string length $sc)
        if test $cur -ge $max_subcommand_length
            set max_subcommand_length $cur
        end
    end
    set -l spacing (math $max_subcommand_length + 1)

    for sc in $subcommands
        set -l helptext (functions "__vf_$sc" | grep '^function ' | head -n 1 | sed -E "s|.*'(.*)'.*|\1|")
        printf "    %-$spacing""s %s\n" $sc (set_color 555)$helptext(set_color normal)
    end
    echo

    if set -q VIRTUALFISH_VERSION
        set help_url "https://virtualfish.readthedocs.org/en/$VIRTUALFISH_VERSION/"
    else
        set help_url "https://virtualfish.readthedocs.org/en/latest/"
    end
    echo "For full documentation, see: $help_url"
end
