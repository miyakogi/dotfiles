function __vf_addpath --description "Adds a path to sys.path in this virtualenv"
    if set -q VIRTUAL_ENV
        set -l site_packages (eval "$VIRTUAL_ENV/bin/python -c 'import distutils.sysconfig; print(distutils.sysconfig.get_python_lib())'")
        set -l path_file $site_packages/_virtualenv_path_extensions.pth

        set -l remove 0
        if test $argv[1] = "-d"
            set remove 1
            set -e argv[1]
        end

        if not test -f $path_file
            echo "import sys; sys.__plen = len(sys.path)" > $path_file
            echo "import sys; new=sys.path[sys.__plen:]; del sys.path[sys.__plen:]; p=getattr(sys,'__egginsert',0); sys.path[p:p]=new; sys.__egginsert = p+len(new)" >> $path_file
        end

        for pydir in $argv
            set -l absolute_path (eval "$VIRTUAL_ENV/bin/python -c 'import os,sys; sys.stdout.write(os.path.abspath(\"$pydir\")+\"\n\")'")
            if not test $pydir = $absolute_path
                echo "Warning: Converting \"$pydir\" to \"$absolute_path\"" 1>&2
            end

            if test $remove -eq 1
                sed -i.tmp "\:^$absolute_path\$: d" "$path_file"
            else
                sed -i.tmp '1 a\
'"$absolute_path"'
' "$path_file"
            end
            command rm -f "$path_file.tmp"
        end
        return 0
    else
        echo "No virtualenv is active."
    end
end
