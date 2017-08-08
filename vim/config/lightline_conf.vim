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
  if &filetype[:5] ==? 'python' && exists('g:virtualenv_name') && g:virtualenv_name !=# ''
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
        \ &filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==? 'unite' ? unite#get_status_string() :
        \ &filetype ==? 'qf' ? 'quickfix(' . len(getqflist()) . ')' :
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
  return winwidth(0) > 90 ? (strlen(&fileencoding) ? &fileencoding : &fileencoding) : ''
endfunction

function! MyMode() abort
  let fname = expand('%:t')
  return fname ==? '__Tagbar__' ? 'Tagbar' :
        \ &filetype ==? 'unite' ? 'Unite' :
        \ &filetype ==? 'vimfiler' ? 'VimFiler' :
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
  if !exists('b:sy') || b:sy.active != 1 || len(b:sy.vcs) < 1
    return ''
  endif

  let vcs = ''

  if winwidth(0) > 70
    let vcs = "\ue0a0 "
    let type=b:sy.vcs[0]
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

function! MySyntaxUpdate() abort
  let qflist = getqflist()
  let err_cnt = len(getloclist(0))
  if len(qflist) + err_cnt == 0
    return ''
  endif

  let l:bufnr = bufnr('%')
  for qfitem in qflist
    if qfitem.bufnr == l:bufnr
      let err_cnt += 1
    endif
  endfor
  return err_cnt ? 'Error: ' . err_cnt : ''
endfunction

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
