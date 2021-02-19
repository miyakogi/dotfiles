scriptencoding utf-8

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=-1
setlocal expandtab

highlight link javaScriptEndColons NONE

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>=><Space>

" ======== smartchr ========
if IsInstalled('vim-smartchr')
  inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
endif
