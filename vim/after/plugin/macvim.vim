scriptencoding utf-8

if !has('mac') || exists('g:loaded_macvim_after')
  finish
endif
let g:loaded_macvim = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:macvim_path() abort
  autocmd InsertEnter * call system('export PATH=/usr/local/bin:$PATH')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim set\ fdm=marker\ ts=2\ sts=2\ sw=2\ tw=0\ et
