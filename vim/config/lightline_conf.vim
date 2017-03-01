scriptencoding utf-8

" ======== Lightline config==
let g:lightline = {
    \ 'mode_map': {'c': 'NORMAL'},
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'filename', 'anzu' ],
    \     [ 'vcs' ]
    \   ],
    \   'right': [
    \     [ 'syntaxcheck' ],
    \     [ 'percent', 'lineinfo' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ]
    \   ]
    \ },
    \ 'tabline': {
    \   'left': [ [ 'tabs' ] ],
    \   'right': [ [ 'project' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'filename_inactive' ] ],
    \   'right': [ ['percent', 'lineinfo'] ]
    \ },
    \ 'component_function': {
    \   'modified': 'MyModified',
    \   'readonly': 'MyReadonly',
    \   'filename': 'MyFilename',
    \   'fileformat': 'MyFileformat',
    \   'filetype': 'MyFiletype',
    \   'fileencoding': 'MyFileencoding',
    \   'percent': 'MyPercent',
    \   'lineinfo': 'MyLineinfo',
    \   'mode': 'MyMode',
    \   'anzu': 'MyAnzu',
    \   'filename_inactive': 'InactiveFilename',
    \   'vcs': 'MyVCS',
    \   'project': 'CurrentWorkingDir',
    \ },
    \ 'component_expand': {
    \   'syntaxcheck': 'MySyntaxUpdate',
    \ },
    \ 'component_type': {
    \   'syntaxcheck': 'error',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|'  }
    \ }

" ======== Lightline functions ========
function! MyVirtualEnv() abort
  if &ft[:5] ==? 'python' && exists('g:virtualenv_name') && g:virtualenv_name !=# ''
    return ' (' . virtualenv#statusline() . ')'
  else
    return ''
  endif
endfunction

function! MyModified() abort
  return &buftype !=# '' ? '' : &modified ? '✚ ' : &modifiable ? '' : '-'
endfunction

function! MyReadonly() abort
  return &buftype ==# '' && &readonly ? has('gui_running') ? '\ue0a2' : 'x' : ''
endfunction

function! MyFilename() abort
  let fname = expand('%:t')
  return fname =~? 'Tagbar' ? '' :
        \ &ft ==? 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft ==? 'unite' ? unite#get_status_string() :
        \ &ft ==? 'qf' ? 'quickfix(' . len(getqflist()) . ')' :
        \ ('' !=? MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' !=? MyModified() ? ' ' . MyModified() : '') .
        \ ('' !=? fname ? fname : '[No Name]')
endfunction

function! MyFileformat() abort
  return winwidth(0) > 90 ? &fileformat : ''
endfunction

function! MyFiletype() abort
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . MyVirtualEnv() : 'no ft') : ''
endfunction

function! MyFileencoding() abort
  return winwidth(0) > 90 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode() abort
  let fname = expand('%:t')
  return fname ==? '__Tagbar__' ? 'Tagbar' :
        \ &ft ==? 'unite' ? 'Unite' :
        \ &ft ==? 'vimfiler' ? 'VimFiler' :
        \ lightline#mode()[0]
endfunction

function! MyPercent() abort
  return winwidth(0) > 70 ? string(float2nr(100.0 * line('.') / line('$'))) . '%' : ''
endfunction

function! MyLineinfo() abort
  if winwidth(0) < 80
    return ''
  endif

  let [_, lnum, col, off] = getpos('.')
  return string(lnum) . ':' . string(col)
endfunction

function! InactiveFilename() abort
  let temp_mode = MyMode()
  return temp_mode !=? 'N' ? temp_mode : MyFilename()
endfunction

function! MyAnzu() abort
  let l:_ = anzu#search_status()
  if winwidth(0) > 80 + l:_
    if strlen(l:_) > 0
      let l:_ = 'Search:' . l:_
    endif
    return l:_
  endif
  return ''
endfunction

function! MyVCS() abort
  if !exists('g:loaded_signify') || &buftype !=# ''
    return ''
  endif

  " 'b:sy' is set by signify
  if !exists('b:sy') || b:sy.active != 1 || b:sy.vcs ==? 'Unknown'
    return ''
  endif

  let vcs = ''

  if winwidth(0) > 70
    let vcs = '\ue0a0 '
    let type=b:sy.vcs
    if type ==? 'git'
      let vcs = vcs . s:fugitive()
    else
      let vcs = vcs . type
    endif
  endif

  if winwidth(0) > 100
    let stats = s:stats()
    let vcs = vcs . '￤' . stats
  endif

  return vcs
endfunction

function! s:stats() abort
  let stats_list = copy(b:sy.stats)
  if stats_list == [-1, -1, -1]
    return ''
  elseif stats_list == [0, 0, 0]
    return 'NotModified'
  else

    let add = string(stats_list[0])
    let modify = string(stats_list[1])
    let remove = string(stats_list[2])

    if has('gui_running')
      let sep = ':'
    else
      let sep = ':'
    endif

    let stats = g:signify_sign_add . sep . add . ' '
          \ . g:signify_sign_change . sep . modify . ' '
          \ . g:signify_sign_delete . sep . remove

  endif
  return stats
endfunction

function! s:fugitive() abort
  if exists('*fugitive#head')
    let head = fugitive#head()
  endif
  if strlen(l:head) > 0
    let head = 'Git:' . head
  endif
  return head
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'
function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let s:qfstatusline_exclude_ft = [
      \ 'dart',
      \ ]
function! MySyntaxUpdate() abort
  let err_cnt = 0
  let warn_cnt = 0
  if exists('g:loaded_qfstatusline') && count(s:qfstatusline_exclude_ft, &filetype) < 0
    let status = ''
    let qflist = getqflist()
    if len(qflist) == 0
      return ''
    endif

    let l:bufnr = bufnr('%')
    let lnum = line('$')
    for qfitem in qflist
      if qfitem.bufnr == l:bufnr
        if qfitem.lnum > 0
          let err_cnt += 1
          let lnum = min([qfitem.lnum, lnum])
        endif
      endif
    endfor
    return err_cnt ? 'Error: L' . lnum . '(' . err_cnt . ')' : ''
  else
    if exists('b:did_pyflakes_plugin') && exists('*PyflakesGetStatusLine')
      let err_cnt = PyflakesGetErrorCount()
    elseif exists('b:loaded_dartanalyzer')
      let err_cnt = dartanalyzer#count_errors()
      let warn_cnt = dartanalyzer#count_warnings()
    else
      let err_cnt = len(getqflist())
    endif
    let status = err_cnt ?  'Error: ' . err_cnt . ' ' : ''
    let status .= warn_cnt ? 'Warn: ' . warn_cnt : ''
    return status
  endif
  return ''
endfunction
let g:Qfstatusline#UpdateCmd = function('lightline#update')
autocmd myvimrc QuickFixCmdPost * call lightline#update()

function! CurrentWorkingDir() abort
  let ret = getcwd()
  if len(ret) > 25
    return '...' . ret[-23:]
  else
    return ret
  endif
endfunction

" }}}

let g:lightline.colorscheme = 'badwolf'
