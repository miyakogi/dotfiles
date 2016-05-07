" Vim filetype plugin file
" Language: python
" Maintainer: Johannes Zellner <johannes@zellner.org>
" Last Change:  2014 Feb 09
" Last Change By Johannes: Wed, 21 Apr 2004 13:13:08 CEST

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1

" Used for file-search by `gf`
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.py
setlocal comments=b:#
setlocal commentstring=#\ %s

set wildignore+=*.pyc,__pycache__

nnoremap <silent> <buffer> ]] :call <SID>Python_jump('/^\(class\\|def\\|async def\)')<cr>
nnoremap <silent> <buffer> [[ :call <SID>Python_jump('?^\(class\\|def\\|async def\)')<cr>
nnoremap <silent> <buffer> ]f :call <SID>Python_jump('/^\s*\(class\\|def\\|async def\)')<cr>
nnoremap <silent> <buffer> [f :call <SID>Python_jump('?^\s*\(class\\|def\\|async def\)')<cr>

if !exists('*<SID>Python_jump')
  fun! <SID>Python_jump(motion) range
    let cnt = v:count1
    let save = @/    " save last search pattern
    mark '
    while cnt > 0
      silent! exe a:motion
      let cnt = cnt - 1
    endwhile
    call histdel('/', -1)
    let @/ = save    " restore last search pattern
  endfun
endif

if has('browsefilter') && !exists('b:browsefilter')
  let b:browsefilter = 'Python Files (*.py)\t*.py\n' .
        \ 'All Files (*.*)\t*.*\n'
endif

" Intents should be set in indent/python.vim
" setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8

" if executable('pydoc3')
"   setlocal keywordprg=pydoc3
" elseif executable('pydoc')
"   setlocal keywordprg=pydoc
" endif
