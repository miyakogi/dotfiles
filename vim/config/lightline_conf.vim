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
    \   'right': [ [ 'cwd' ] ]
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
    \   'cwd': 'CurrentWorkingDir',
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
        \ match(fname, 'denite') >= 0 ? 'denite' :
        \ match(fname, 'defx') >= 0 ? 'defx' :
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

  " for denite support
  if fname ==? '[denite]'
    let mode_str = substitute(denite#get_status_mode(), ' ', '', 'g')
    let mode_str = substitute(mode_str, '-', '', 'g')
    call lightline#link(tolower(mode_str[0]))
    return mode_str[0]
  endif

  return fname ==? '__Tagbar__' ? 'Tagbar' :
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
  if !exists('*anzu#search_status')
    return ''
  endif

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
  if !get(g:, 'loaded_signify') || &buftype !=# ''
    return ''
  endif

  " 'b:sy' is set by signify
  if !exists('b:sy') || !has_key(b:sy, 'vcs') || len(b:sy.vcs) < 1
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
  if !get(g:, 'loaded_fugitive')
    return ''
  endif

  let head = fugitive#head()
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
  if !get(g:, 'loaded_ale')
    return ''
  endif

  let buf = bufnr('%')
  let counts = ale#statusline#Count(buf)

  if counts.error + counts.style_error > 0
    return g:ale_sign_error
  elseif counts.warning + counts.style_warning > 0
    return g:ale_sign_warning
  else
    return ''
  endif
endfunction

function! CurrentWorkingDir() abort
  let cwd = substitute(getcwd(), $HOME, '~', '')
  if len(cwd) > 25
    return '...' . cwd[-23:]
  endif
  return cwd
endfunction

" }}}

let g:lightline.colorscheme = 'snazzy'
