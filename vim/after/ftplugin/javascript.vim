scriptencoding utf-8

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=-1
setlocal expandtab

highlight link javaScriptEndColons NONE

" ======== quickrun ========
if exists('g:quickrun_config')
  let g:quickrun_config['javascript'] = {
        \ 'command': 'node',
        \ 'runner': 'vimproc',
        \ }

endif

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>=><Space>

" ======== jscomplete ========
if IsInstalled('jscomplete-vim')
  autocmd myvimrc FileType javascript setlocal omnifunc=jscomplete#CompleteJS
endif

" ======== smartchr ========
if IsInstalled('vim-smartchr')
  inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
endif
