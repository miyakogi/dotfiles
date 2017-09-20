scriptencoding utf-8

if get(b:, 'loaded_python_ftplugin_after')
  finish
endif
let b:loaded_python_ftplugin_after = 1

" ======== Vim General Settings ========"{{{
" ==== PEP 8 Indent rule ====
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal textwidth=0
setlocal colorcolumn=80
setlocal formatoptions=cq
setlocal wrap

" Folding
setlocal foldmethod=indent
setlocal foldlevel=20
setlocal concealcursor=i " for jedi

" ======== Abbreviations ========
iabbrev <buffer> se self
iabbrev <buffer> sel self

" ======== textobj-heredoc ========
let b:heredoc_start_pattern = '\v(''''''|""")'
let b:heredoc_end_pattern = '\v(''''''|""")'

" ======== mappings ========
inoremap <buffer> <C-l> <C-g>u<Space>-><Space>

"}}}

" ======== Initialization ========"{{{
" These functions should move to filtype specific settings later
let s:initialized = 0
function! s:init() abort
  function! s:python_cmd() abort
    if expand('%:t') !~? 'test_'
      return 'python'
    endif

    if $VIM_TEST_RUNNER ==# 'unittest'
      return 'python_unittest'
    elseif $VIM_TEST_RUNNER ==# 'green'
      return 'green'
    elseif $VIM_TEST_RUNNER ==# 'nose'
      return 'nose'
    elseif $VIM_TEST_RUNNER ==# 'pytest'
      return 'pytest'
    else
      return 'python_unittest'
    endif
  endfunction

  function! s:python_shell() abort
    let first_line = getline(1)
    if first_line =~# '^#!' && executable(first_line[2:])
      let cmd =  first_line[2:]
    else
      let cmd = executable('python3') ? 'python3' : 'python'
    endif
    execute '!' . cmd ' %'
    return ''
  endfunction

  function! s:quickrun_py() abort
    if exists(':QuickRun')
      execute 'QuickRun ' . s:python_cmd()
    else
      call s:python_shell()
    endif
  endfunction

  " ======== jedi ========
  function! s:jedi_rename() abort
    packadd jedi-vim
    call jedi#rename()
  endfunction

  function! s:jedi_usages()
    packadd jedi-vim
    call jedi#usages()
    if len(getqflist()) < 10 && &filetype ==# 'qf'
      resize 10
    endif
  endfunction

  function! s:jedi_goto_a()
    packadd jedi-vim
    call jedi#goto_assignments()
  endfunction

  function! s:jedi_doto_d()
    packadd jedi-vim
    call jedi#goto_definitions()
  endfunction

  function! s:jedi_doc()
    packadd jedi-vim
    call jedi#show_documentation()
    if winheight(0) < 10
      resize 10
    endif
  endfunction

  let s:initialized = 1
endfunction

if !s:initialized | call s:init() | endif
"}}}

" ======== run script ========
nnoremap <buffer><silent> <Leader>r :<C-u>call <SID>quickrun_py()<CR>
nnoremap <expr><buffer> <Leader>p <SID>python_shell()

" ======== Jedi-vim ========
command! -buffer JediRename call <SID>jedi_rename()
nnoremap <buffer><silent> gl :<C-u>call <SID>jedi_usages()<CR>
nnoremap <buffer><silent> gd :<C-u>call <SID>jedi_goto_a()<CR>
nnoremap <buffer><silent> gD :<C-u>call <SID>jedi_doto_d()<CR>
nnoremap <buffer><silent> K :<C-u>call <SID>jedi_doc()<CR>

" ========= vim-flake8 ========
if exists(':Unite')
  let g:flake8_loc_open_cmd = 'Unite location_list -no-quit' .
        \ ' -winheight=10 -buffer-name=pep8'
  let g:flake8_loc_close_cmd = 'UniteClose pep8'
endif
if exists(':Flake8')
  nnoremap <buffer> <F7> :<C-u>Flake8<CR>
endif

" ======== CoveragePy ========
if exists(':Coveragepy')
  nnoremap <buffer> <leader>cr :<C-u>Coveragepy refresh<CR>
  nnoremap <buffer> <leader>cc :<C-u>Coveragepy show<CR>
  nnoremap <buffer> <leader>cs :<C-u>Coveragepy session<CR>
  nnoremap <buffer> <leader>cp :<C-u>CoveragepyPragmaToggle<CR>
endif

" ======== smartchr ========
if IsInstalled('vim-smartchr')
  inoremap <buffer><expr> = smartchr#loop(' = ', '=', ' == ', '==')
endif
