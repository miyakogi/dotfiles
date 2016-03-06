scriptencoding utf-8

if exists('g:loaded_pjlocal')
  finish
endif
let g:loaded_pjlocal = 1

let s:save_cpo = &cpo
set cpo&vim

let s:debug = 0

if !exists('g:pjlocal_scriptname')
  let g:pjlocal_scriptname = '.pjlocal.vim'
endif

" Load settings for each location.
augroup pjlocal
  autocmd!
  autocmd BufWinEnter,WinEnter * call s:win_enter(expand('<afile>:p:h'))
augroup END

function! s:win_leave(loc)
  if exists('g:pjlocal_projectname')
    unlet g:pjlocal_projectname
  endif
  if !exists('g:pjlocal_rootdir') || g:pjlocal_rootdir == ''
    return ''
  else
    if match(a:loc, g:pjlocal_rootdir) == -1
      call s:leave_project()
    endif
  endif
endfunction

function! s:win_enter(loc)
  if !exists('g:pjlocal_rootdir')
    let g:pjlocal_rootdir=''
  else
    call s:win_leave(a:loc)
  endif
  let files = findfile(g:pjlocal_scriptname,
        \              escape(a:loc, ' ') . ';', -1)
  let l:script = ''
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
    let l:script = i
  endfor
  if l:script != ''
    let g:pjlocal_rootdir = substitute(l:script, '/' . g:pjlocal_scriptname . '$', '', 'g' )
    call s:enter_project()
  else
    if s:debug | echomsg 'No Project' | endif
  endif
endfunction

function! s:enter_project()
  if exists('*PjLocalEnter')
    call PjLocalEnter()
    if s:debug | echomsg 'Enter project: ' . bufname('') | endif
  endif
endfunction

function! s:leave_project()
  if exists('*PjLocalLeave')
    call PjLocalLeave()
    if s:debug | echomsg 'Leave project: ' . bufname('') | endif
    delfunction PjLocalLeave
  endif
  if exists('*PjLocalEnter')
    delfunction PjLocalEnter
  endif
endfunction

function! PjLocalStatus()
  if exists('g:pjlocal_projectname')
    return g:pjlocal_projectname
  elseif exists('g:pjlocal_rootdir')
    if isdirectory(g:pjlocal_rootdir) &&
          \ match(expand('%:p'), g:pjlocal_rootdir) != -1
      let dir = substitute(g:pjlocal_rootdir, '^.*/', '', 'g')
      return dir
    endif
  endif
  return ''
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
