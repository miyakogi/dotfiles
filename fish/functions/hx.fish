# FIXME: remove once https://github.com/helix-editor/helix/issues/10089 is fixed
function hx
    command hx $argv
    printf '\033[0 q'
end
