scriptencoding utf-8

" ======== change dir when current buffer changed ========
" http://nanasi.jp/articles/vim/cd_vim.html
function! s:autolcd_autolcd()
  if &buftype == ''
    let autolcd_current_dir = substitute(fnamemodify(resolve(expand('%:p')), ":h"), '\s', '\\\ ', 'g')
    let autolcd_cmd = 'lcd ' . autolcd_current_dir
    if match(autolcd_current_dir, '\v^(fugitive|quickrun):') < 0
      execute autolcd_cmd
    endif
  endif
endfunction

function! s:autolcd_enable()
  augroup autolcd
    autocmd!
    autocmd BufWinEnter,WinEnter * call s:autolcd_autolcd()
  augroup END
endfunction

function! s:autolcd_disable()
  augroup autolcd
    autocmd!
  augroup END
endfunction

command! -nargs=0 AutoLCDEnable call s:autolcd_enable()
command! -nargs=0 AutoLCDDisable call s:autolcd_disable()

augroup autolcd
  autocmd!
  autocmd VimEnter * execute "call s:autolcd_enable()"
augroup END
