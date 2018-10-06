scriptencoding utf-8

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=-1
setlocal expandtab

inoremap <C-l> <Space>=><Space>

" ======== SmartChr ========
if g:IsInstalled('vim-startchr')
  inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
  inoremap <buffer> <expr> + smartchr#loop(' + ', '+')
  inoremap <buffer> <expr> - smartchr#loop(' - ', '-', '--')
  inoremap <buffer> <expr> * smartchr#loop(' * ', '*')
  inoremap <buffer> <expr> , smartchr#loop(', ', ',')
  inoremap <buffer> <expr> : smartchr#loop(': ', ':')
endif
