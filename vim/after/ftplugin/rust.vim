scriptencoding utf-8

if get(b:, 'loaded_rust_ftplugin_after')
  finish
endif
let b:loaded_rust_ftplugin_after = 1

" ======== Abbreviations ========
iabbrev <buffer> se self
iabbrev <buffer> sel self

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>-><Space>

" ======== Initialization ========"{{{
let s:initialized = 0
function! s:init() abort
  function! <SID>quickrun_cargo() abort
    if !executable('cargo') || expand('%:t') ==? 'main.rs'
      let cmd = 'QuickRun rust'
    else
      if finddir('tests', './;$HOME') !=# ''
        let args = ' --test ' . expand('%:t:r') . ' -- --nocapture'
      else
        let args = ' --lib ' . expand('%:t:r') . ' -- --nocapture'
      endif
      let cmd = 'QuickRun cargo/test -args "' . l:args . '"'
    endif
    execute cmd
  endfunction

  let s:initialized = 1
endfunction

if !s:initialized | call s:init() | endif
"}}}

nnoremap <buffer> <Leader>r :<C-u>call <SID>quickrun_cargo()<CR>
