if exists('g:loaded_ftdetect_user')
  finish
endif
let g:loaded_ftdetect_user = 1
augroup filetypedetect_user

" ======== python ========
autocmd BufNewFile,BufRead *.py3 set filetype=python

function! s:PythonTest()
  let l:test_tool = get(g:, 'python_test_tool', 'pytest')
  if l:test_tool !=# ''
    execute 'set filetype=python.' . l:test_tool
  endif
endfunction

function! s:TestScript()
  let ext = expand('%:e')
  if ext ==? 'py' || ext ==? 'py3'
    call s:PythonTest()
  endif
endfunction

autocmd BufRead,BufNewFile test* call s:TestScript()

" ======== jinja2 ========
autocmd BufNewFile,BufRead *.jinja,*.jinja2 set filetype=htmljinja

" ======== markdown ========
autocmd BufNewFile,BufRead *.MD,*.MKD set filetype=markdown

" ======== CoffeeScript ========
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" ======== JavaScript (jsx) ========
autocmd BufNewFile,BufRead *.jsx set filetype=javascript

" ======== Dart ========
autocmd BufNewFile,BufRead *.dart set filetype=dart

augroup filetypedetect
