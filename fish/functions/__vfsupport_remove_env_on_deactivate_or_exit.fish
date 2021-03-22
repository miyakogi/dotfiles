function __vfsupport_remove_env_on_deactivate_or_exit --on-event virtualenv_did_deactivate --on-process %self
    if begin; set -q _VF_TEMPORARY_ENV; and [ $_VF_TEMPORARY_ENV = (basename $VIRTUAL_ENV) ]; end
        echo "Removing temporary virtualenv" $_VF_TEMPORARY_ENV
        if command -q trash
            command trash $VIRTUAL_ENV
        else
            command rm -rf $VIRTUAL_ENV
        end
        set -e _VF_TEMPORARY_ENV
    end
end
