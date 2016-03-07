scriptencoding utf-8

nnoremap <buffer> <Leader>p :!py.test -s -v %<CR>

" ======== quickrun ========
if !get(g:, 'loaded_watchdogs_pytest')
  if exists('g:quickrun_config')
    let g:quickrun_config['pytest'] = {
          \ 'command': 'py.test',
          \ 'runner': get(g:, 'py_runner', 'system'),
          \ 'cmdopt': '-s -v',
          \ 'exec': '%c %o %s',
          \ 'runmode': 'async:remote:vimproc',
          \ 'outputter/buffer/filetype': 'pytest_result',
          \ 'outputter/buffer/split': ':botright 12sp',
          \ 'hook/shebang/enable': 0,
          \ }
    let g:quickrun_config['python.pytest'] =deepcopy(g:quickrun_config['pytest'])
    if get(g:, 'loaded_watchdogs')
      call watchdogs#setup(g:quickrun_config)
      let g:loaded_watchdogs_pytest = 1
    endif
  endif
endif
