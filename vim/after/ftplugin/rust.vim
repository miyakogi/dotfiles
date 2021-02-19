scriptencoding utf-8

if get(b:, 'loaded_rust_ftplugin_after')
  finish
endif
let b:loaded_rust_ftplugin_after = 1

" ======== Abbreviations ========
" iabbrev <buffer> se self
" iabbrev <buffer> sel self

" ======== Initialization ========"{{{
if !get(s:, 'initialized')
  function! <SID>quickrun_cargo() abort
    if !executable('cargo') || expand('%:t') ==? 'main.rs'
      let cmd = 'QuickRun rust'
    else
      if index(split(expand('%:p')), 'tests') > 0
        let args = '--test ' . expand('%:t:r') . ' -- --nocapture'
      elseif expand('%:t') ==? 'lib.rs'  " main module
        let args = '--lib -- --nocapture'
      elseif expand('%:t') ==? 'mod.rs'  " in module top
        let args = '--lib -- --nocapture ' . expand('%:p:h:t')
      else                               " in normal module
        let args = '--lib -- --nocapture ' . expand('%:t:r')
      endif
      let cmd = 'QuickRun cargo/test -args "' . l:args . '"'
    endif
    execute cmd
  endfunction

  let s:initialized = 1
endif
"}}}

" ======== mappings ========
nnoremap <buffer><silent> <Leader>r :<C-u>call <SID>quickrun_cargo()<CR>
imap <buffer><expr> <C-l> IsInstalled('smartchr') ? smartchr#loop(' -> ', ' => ') : ' -> '
