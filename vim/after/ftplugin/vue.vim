scriptencoding utf-8

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>=><Space>

" ======== smartchr ========
if IsInstalled('vim-smartchr')
  inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
  inoremap <buffer> <expr> , smartchr#loop(', ', ',')
endif
