scriptencoding utf-8

nnoremap <buffer> <Leader>p :!py.test -s -v %<CR>

" ======== quickrun ========
if exists('g:quickrun_config')
  let g:quickrun_config['pytest'] = {
        \ 'command': 'py.test',
        \ 'runner': g:py_runner,
        \ 'cmdopt': '-s -v',
        \ 'exec': '%c %o %s',
        \ 'runmode': 'async:remote:vimproc',
        \ 'outputter/buffer/filetype': 'pytest_result',
        \ 'outputter/buffer/split': ':botright 12sp',
        \ 'hook/shebang/enable': 0,
        \ }
  let g:quickrun_config['python.pytest'] =deepcopy(g:quickrun_config['pytest'])
endif
