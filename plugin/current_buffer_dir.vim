" ======== Add 'CD' command to cd CurrentBufferDir ========
let s:file_name = expand("%")
if has('vim_starting') && s:file_name != ""
  autocmd Vimenter * cd %:h
elseif has('vim_starting')
  autocmd Vimenter * cd $HOME
endif

function! Cdr()
  let s:file_name = expand("%")
  if s:file_name != ""
    cd %:h
  endif
endfunction
com! CD call Cdr()
