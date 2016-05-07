" ======== Markdown previw and conversion ========

if !exists("g:mkdprev_browser")
  let g:mkdprev_browser = 'chromium-browser'
endif

if !exists("g:mkdprev_options")
  let g:mkdprev_options = '--profile-directory="Profile 8"'
endif

if !exists("g:mkdconv_command")
  let g:mkdconv_command = 'markdown'
  " let g:mkdconv_command = 'pandoc'
endif

if !exists("g:mkdconv_options")
  let g:mkdconv_options = ''
  " Example for pandoc
  " let g:mkdconv_options = '-f markdown -t html'
endif

if !exists("g:mkdconv_enc")
  let g:mkdconv_enc = 'utf8'
endif

if !exists("g:mkdconv_rm_blankline")
  let g:mkdconv_rm_blankline = 1
endif

if !exists("g:mkdconv_output_file")
  let g:mkdconv_output_file = 0
endif

function! s:MkdPrev()
  call system(g:mkdprev_browser . ' '. g:mkdprev_options . ' ' . expand('%'))
endfunction

function! s:refresh_convbuf(bufname)
  if bufexists(a:bufname)
    let l:bufnr = bufnr(a:bufname)
    execute l:bufnr . "wincmd w"
    execute "bdelete! " . a:bufname
  endif
  " Delete existing output file
  if filereadable(a:bufname)
    call delete(a:bufname)
  endif
endfunction

function! s:MkdConv()
  " Convert markdown to html
  let html = system(g:mkdconv_command . ' ' . g:mkdconv_options . ' ' . expand('%'))
  if g:mkdconv_rm_blankline == 1
    let html = substitute(html, '\n\n', '\n', "g")
  endif
  let html_list = split(html, '\n')
  " Copy html into clipboard
  let @+ = html

  " Save the current bufname
  let original_bufname = bufname("%")

  " Create a new blank buffer
  if g:mkdconv_output_file != 0
    let output_file = expand('%:r') . '.html'
    let bufname = output_file
    let split_buftype = ""
  else
    let bufname = "mkdconv_html"
    let split_buftype = "nofile"
  endif
  let split_cmd = "new " . bufname
  call s:refresh_convbuf(bufname)
  execute split_cmd
  execute "set buftype=" . split_buftype
  execute "set filetype=html"

  " Paste html to the new buffer
  call append(line('.'), html_list)
  " Execute commands after pasting html
  if &bt == ""
    execute "w"
  else
    if (v:version > 704 || (v:version == 703 && has('patch1261')))
      execute "nnoremap <buffer><nowait> q <C-w>c"
    else
      execute "nnoremap <buffer> q <C-w>c"
    endif
  endif

  " Go back to the original window
  let original_bufnr = bufnr(original_bufname)
  execute original_bufnr . "wincmd w"
endfunction

function! Mkd2RST(ext)
  if !executable('pandoc')
    echomsg '"pandoc" is not executable.'
    return
  endif
  let dir = expand('%:p:h')
  let ifile = expand('%:p:t')
  let basename = fnamemodify(ifile, ':r')
  if a:ext == ''
    let outfile = basename . '.rst'
  else
    let outfile = basename . '.' . a:ext
  endif
  let cmd = 'pandoc -f markdown_github -t rst -o ' . outfile . ' ' . ifile
  let g:cmd = cmd
  call system(cmd)
endfunction

command! MkdPrev call s:MkdPrev()
command! MkdConv call s:MkdConv()
command! -nargs=? Mkd2RST call Mkd2RST(<q-args>)

" vim set\ fdm=marker\ ts=2\ sts=2\ sw=2\ tw=0\ et
