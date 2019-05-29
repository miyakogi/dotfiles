scriptencoding utf-8

" ======== Settings ========

" Delete : with pre- and post- word by <C-w>
setlocal iskeyword+=:

setlocal formatoptions-=ro

" ======== Key mappings for tex-compile.vim ========

" tex -> dvi -> pdf
nnoremap <buffer> <c-l>a :call TeXCompile.all()<CR>
nnoremap <buffer> <Leader>l :call TeXCompile.all()<CR>

" tex -> dvi
nnoremap <buffer><expr> <C-l>l TeXCompile.t2d()
nnoremap <buffer><expr> <C-l><C-l> TeXCompile.t2d()

" open compile.log
nnoremap <buffer> <C-l>c :<C-u>call TeXCompile.log()<CR>

" bibtex
nnoremap <buffer><expr> <C-c>b TeXCompile.bib()

" dvi -> pdf
nnoremap <buffer><expr> <C-l>p TeXCompile.d2p()

" Open dvi
nnoremap <buffer><expr> <C-l>d TeXCompile.dviView()

" Open pdf
nnoremap <buffer><expr> <C-l>v TeXCompile.pdfView()
