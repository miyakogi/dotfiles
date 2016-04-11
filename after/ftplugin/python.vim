scriptencoding utf-8

if get(b:, 'loaded_python_ftplugin_after')
  finish
endif
let b:loaded_python_ftplugin_after = 1

" ==== PEP 8 Indent rule ====
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal textwidth=0
setlocal colorcolumn=80
setlocal formatoptions=cq
setlocal wrap

" Folding
setlocal foldmethod=indent
setlocal foldlevel=20
setlocal concealcursor=i " for jedi

" ======== Abbreviations ========
iabbrev <buffer> se self
iabbrev <buffer> sel self

" ======== textobj-heredoc ========
let b:heredoc_start_pattern = '\v(''''''|""")'
let b:heredoc_end_pattern = '\v(''''''|""")'

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>-><Space>
