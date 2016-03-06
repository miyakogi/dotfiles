scriptencoding utf-8

setlocal formatoptions-=ro

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" ======== Help ========
nnoremap <buffer> <C-h> :<C-u>help <C-r><C-w><CR>

" ======== vint ========
if executable('vint')
  nnoremap <Leader>p :<C-u>vint %<CR>
endif
