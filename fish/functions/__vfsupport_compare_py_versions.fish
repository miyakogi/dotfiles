function __vfsupport_compare_py_versions --description "Return status code 1 if specified Python version is less than another"
    set -l version_to_compare (string split . $argv[1])
    set -l reference_version (string split . $argv[2])
    if test $version_to_compare[1] -lt $reference_version[1]
        return 1
    else if test $version_to_compare[2] -lt $reference_version[2]
        return 1
    else if test $version_to_compare[2] -gt $reference_version[2]
        return 0
    else if test $version_to_compare[3] -lt $reference_version[3]
        return 1
    end
    return 0
end
