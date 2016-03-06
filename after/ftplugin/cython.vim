scriptencoding utf-8

function! s:load_file(file)
  if filereadable(a:file)
    execute "source " . a:file
  endif
endfunction

call s:load_file($VIMRUNTIME . "/ftplugin/python.vim")
call s:load_file(expand("<sfile>:p:h") . "/python.vim")
