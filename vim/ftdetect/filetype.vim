if exists('g:loaded_ftdetect_user')
  finish
endif
let g:loaded_ftdetect_user = 1
augroup filetypedetect_user

" ======== python ========
autocmd BufNewFile,BufRead *.py3 set filetype=python

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
