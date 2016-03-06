scriptencoding utf-8

if get(b:, 'loaded_python_ftplugin_after', 0)
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

" ======== Test ========
let g:python_test_tool = get(g:, 'python_test_tool', 'pytest')
if &ft ==? 'python'
  nnoremap <buffer> <Leader>p :!python %<CR>
endif

" ======== quickrun ========
if exists('g:quickrun_config')
  let g:py_runner='vimproc'
  let g:quickrun_config['python'] = {
        \ 'runner': g:py_runner,
        \}

  " ======== watchdogs ========
  " pyflakes
  if executable('pyflakes3')
    let s:pyflakes_py = 'pyflakes3'
    let s:pyflakes_opt = ''
  elseif executable('python3')
    let s:pyflakes_py = 'python3'
    let s:pyflakes_opt = '-m pyflakes'
  elseif executable('pyflakes')
    let s:pyflakes_py = 'pyflakes'
    let s:pyflakes_opt = ''
  else
    let s:pyflakes_py = 'python'
    let s:pyflakes_opt = '-m pyflakes'
  endif
  let g:quickrun_config['watchdogs_checker/pyflakes'] = {
        \ 'command' : s:pyflakes_py,
        \ 'cmdopt' : s:pyflakes_opt,
        \ 'exec'    : '%c %o %s:p',
        \ 'errorformat' : '%f:%l:%m',
        \ }

  " flake8
  if executable('python3')
    let s:flake8_py = 'python3'
    let s:flake8_opt = '-m flake8'
  elseif executable('flake8')
    let s:flake8_py = 'flake8'
    let s:flake8_opt = ''
  else
    let s:flake8_py = 'python'
    let s:flake8_opt = '-m flake8'
  endif
  let g:quickrun_config['watchdogs_checker/flake8'] = {
        \ 'command' : s:flake8_py,
        \ 'cmdopt' : s:flake8_opt,
        \ 'exec'    : '%c %o %s:p',
        \ 'errorformat' : '%f:%l:%c: %m',
        \ }

  " mypy
  let g:quickrun_config['watchdogs_checker/mypy'] = {
        \ 'command' : 'mypy',
        \ 'exec'    : '%c %o %s:p',
        \ 'errorformat' : '%A%f: %m:,%Z%f\, line %l: %m,%f\, line %l: %m',
        \ }

  " Jedi-linter
  let g:quickrun_config['watchdogs_checker/jedi'] = {
        \ 'command' : 'python',
        \ 'cmdopt' : '-m jedi linter',
        \ 'exec'    : '%c %o %s:p',
        \ 'errorformat' : '%f:%l:%c: %t%n %m',
        \ }

  " Set default for python
  let g:quickrun_config['python/watchdogs_checker'] = {
        \ 'type' : 'watchdogs_checker/pyflakes',
        \ }
  let g:quickrun_config['python.pytest/watchdogs_checker'] = {
        \ 'type' : 'watchdogs_checker/pyflakes',
        \ }

  unlet s:pyflakes_py
  unlet s:pyflakes_opt
  unlet s:flake8_py
  unlet s:flake8_opt
endif
