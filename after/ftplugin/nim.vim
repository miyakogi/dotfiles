scriptencoding utf-8

if match(expand('%:t'), '\d') == 0
  nnoremap <buffer><silent> <Leader>r :let g:cpos=getcurpos()<CR>ggVG:QuickRun<CR><Esc>:call setpos('.', g:cpos)<CR>
endif
