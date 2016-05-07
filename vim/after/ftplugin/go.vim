scriptencoding utf-8

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

if exists("b:did_ftplugin_go_user")
  finish
endif
let b:did_ftplugin_go_user = 1

if exists('b:gomisc_loaded')
  finish
endif

let b:gomisc_loaded = 1

if exists("b:did_ftplugin_go_fmt") && !exists(":Fmt")
  unlet b:did_ftplugin_go_fmt
  if filereadable("$GOROOT/misc/vim/ftplugin/go/fmt.vim")
    source $GOROOT/misc/vim/ftplugin/go/fmt.vim
  endif
endif

if exists("b:did_ftplugin_go_import") && !exists(":Import")
  unlet b:did_ftplugin_go_import
  if filereadable("$GOROOT/misc/vim/ftplugin/go/import.vim")
    source $GOROOT/misc/vim/ftplugin/go/import.vim
  endif
endif

" ======== textobj-heredoc ========
let b:heredoc_start_pattern = '\v`'
let b:heredoc_end_pattern = '\v`'
