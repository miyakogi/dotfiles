scriptencoding utf-8

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=-1
setlocal expandtab

if g:IsInstalled('vim-quickrun')
  nnoremap <buffer> <Leader>p :QuickRun coffee_compile<CR>
endif
