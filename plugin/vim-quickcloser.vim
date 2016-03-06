scriptencoding utf-8

function! s:initialize_quickcloser()
  if !exists('g:quick_closer_filetypes')
    return
  endif

  augroup quick_closer
    autocmd!
  augroup END

  for l:filetype in g:quick_closer_filetypes
    let cmd = "autocmd quick_closer FileType " . l:filetype . " nnoremap <buffer> <nowait> q <C-w>c"
    execute cmd
  endfor
endfunction

augroup quick_closer
  autocmd!
  autocmd VimEnter * call s:initialize_quickcloser()
augroup END
