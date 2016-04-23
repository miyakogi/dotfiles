" ============================================
"  Plugin settings
" ============================================

function! IsInstalled(name) abort
  if match(&runtimepath, 'dein') >= 0
    return !dein#check_install([a:name])
  else
    if match(&runtimepath, a:name) >= 0
      return 1
    endif
  endif
  return 0
endfunction

" ======== ColorScheme ========
syntax enable
if exists('g:MyColorScheme')
  try
    execute 'colorscheme ' . g:MyColorScheme
  catch /^Vim\%((\a\+)\)\=:E185/
    echomsg 'Failed to load colorscheme "' . g:MyColorScheme
          \ . '". Use desert instead.'
    colorscheme desert
  endtry
endif

" ======== Unite ======== {{{
if get(g:, 'loaded_unite')
  " unite prefix key
  nnoremap [unite] <Nop>
  nmap <Leader>f [unite]
  autocmd myvimrc FileType unite nmap <buffer><silent><nowait> q <PLUG>(unite_exit)

  " ======== Unite Key binding ========
  nnoremap <silent> [unite]f :<C-u>Unite file file_mru buffer<CR>
  nnoremap <silent> [unite]b :<C-u>Unite buffer neomru/file file<CR>
  nnoremap <silent> [unite]m :<C-u>Unite neomru/file buffer file locate<CR>
  nnoremap <silent> [unite]t :<C-u>Unite outline<CR>
  nnoremap <silent> [unite]u :<C-u>Unite
  nnoremap <silent> [unite]e :<C-u>Unite -start-insert locate<CR>
  nnoremap <silent> [unite]c :<C-u>Unite change<CR>
endif

"}}}

" ======== VimFiler ========"{{{
if get(g:, 'loaded_vimfiler')
  function! s:vimfiler_init()
    nmap <silent><buffer> q <Plug>(vimfiler_hide)
    nmap <silent><buffer> I <Plug>(vimfiler_toggle_visible_ignore_files)
    nmap <silent><buffer> u <Plug>(vimfiler_smart_h)
    nmap <silent><buffer> <Enter> <Plug>(vimfiler_expand_or_edit)
    nmap <silent><buffer> a <Plug>(vimfiler_toggle_mark_current_line)
    vmap <silent><buffer><nowait> a <Plug>(vimfiler_toggle_mark_selected_lines)
    nmap <silent><buffer> <C-Space> <Plug>(vimfiler_clear_mark_all_lines)
    nmap <silent><buffer> ma <Plug>(vimfiler_new_file)
    nmap <silent><buffer> mA <Plug>(vimfiler_make_directory)
    nmap <silent><buffer> mm <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_rename_file)
    nmap <silent><buffer> mc <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_copy_file)
    nmap <silent><buffer> md <Plug>(vimfiler_mark_current_line)<Plug>(vimfiler_delete_file)
    nmap <silent><buffer> ~ <Plug>(vimfiler_switch_to_home_directory)
    nmap <silent><buffer><nowait> s <Plug>(vimfiler_split_edit_file)
    nmap <silent><buffer><nowait><expr> S vimfiler#do_action('split')
    nmap <silent><buffer> x <Plug>(vimfiler_expand_tree)
    nmap <silent><buffer><expr> t vimfiler#do_action('tabopen')
    nmap <silent><buffer> yy <Plug>(vimfiler_yank_full_path)
    nmap <silent><buffer> <C-l> <Plug>(vimfiler_redraw_screen)
    nmap <silent><buffer> <C-g> <Plug>(vimfiler_print_filename)
  endfunction

  augroup myvimrc
    autocmd FileType vimfiler call s:vimfiler_init()
  augroup END
  call vimfiler#custom#profile('default', 'context', {
      \ 'safe': 0,
      \ 'explorer': 1
      \ })
endif
"}}}

" ======== Signify ======== {{{
if get(g:, 'loaded_signify')
  autocmd myvimrc ColorScheme,Syntax * highlight link SignifySignAdd LineNr
        \ | highlight link SignifySignChange PreProc
        \ | highlight SignifySignDelete guifg=#EE3333 ctermfg=red
endif
"}}}

" ======== anzu ======== {{{
if get(g:, 'loaded_anzu')
  nmap n <Plug>(anzu-n)
  nmap N <Plug>(anzu-N)
  " nnoremap <expr> n anzu#mode#mapexpr("n", "", "zzzv")
  " nnoremap <expr> N anzu#mode#mapexpr("N", "", "zzzv")
  nmap * <Plug>(anzu-star)
  nmap # <Plug>(anzu-sharp)
  " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
  " 検索ヒット数の表示を消去する
  autocmd myvimrc CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
endif
"}}}

" ======== visualstar ======== {{{
if get(g:, 'loaded_visualstar')
  xmap * <Plug>(visualstar-*)
  xmap g* <Plug>(visualstar-g*)
  xmap # <Plug>(visualstar-#)
  xmap g# <Plug>(visualstar-g#)
endif
"}}}

" ======== NeoComplete ======== {{{
if get(g:, 'loaded_neocomplete')
  " ======== Key mappings ========
  " inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr> <C-x><C-f> g:neocomplete#start_manual_complete('file')
  inoremap <expr> <Tab> pumvisible() ? neocomplete#complete_common_string() : "\<TAB>"

  " ==== Recommended key-mappings ====
  " Close popup and save indent by <CR>
  inoremap <silent><expr> <CR> MyNeocomCR()
  function! MyNeocomCR()
    let l:delimitMateCR = delimitMate#ExpandReturn()
    return neocomplete#close_popup() . l:delimitMateCR
  endfunction

  " disable on python
  autocmd myvimrc FileType python NeoCompleteLock

  if exists('*NimComplete')
    if &filetype ==# 'nim'
      setlocal omnifunc=NimComplete
    endif
    autocmd myvimrc FileType nim setlocal omnifunc=NimComplete
  endif
endif
"}}}

" ======== NeoSnippets ======== {{{
if get(g:, 'loaded_neosnippet')
  imap <C-Space> <Plug>(neosnippet_expand_or_jump)
  smap <C-Space> <Plug>(neosnippet_expand_or_jump)
  " For snippet_complete marker.
  " if has('conceal')
  "   set conceallevel=2 concealcursor=i
  " endif
endif
"}}}

" ======== Abolish ========"{{{
function! s:init_abolish() abort
  if exists(':Abolish')
    Abolish teh the
    Abolish qunatum quantum
    Abolish fro for
    Abolish sefl self
    Abolish strign string
    Abolish tokne{,s} token{}
  else
    iabbrev teh the
    iabbrev qunatum quantum
    iabbrev fro for
    iabbrev sefl self
    iabbrev strign string
    iabbrev tokne token
    iabbrev toknes tokens
  endif
endfunction
"}}}

" ======== Tcomment ======== {{{
if get(g:, 'loaded_tcomment')
  nnoremap gcl      :TCommentRight<CR>
  nnoremap gcp      vip:TCommentBlock<CR>
  xnoremap gb       :TCommentBlock<CR>
  xnoremap gi       :TCommentInline<CR>
  inoremap <C-g>c   <C-o>:TComment<CR>
  inoremap <C-g>l   <C-o>:TCommentRight<CR>
endif
"}}}

" ======== surround.vim ======== {{{
if get(g:, 'loaded_surround')
  " Original mapping
  nmap ds  <Plug>Dsurround
  nmap cs  <Plug>Csurround
  nmap ys  <Plug>Ysurround
  nmap yS  <Plug>YSurround
  nmap yss <Plug>Yssurround
  nmap ySs <Plug>YSsurround
  nmap ySS <Plug>YSsurround

  " Custom mapping
  nmap s   <Plug>Ysurround
  " nmap S   <Plug>YSurround
  nmap ss  <Plug>Yssurround
  " nmap Ss  <Plug>YSsurround
  " nmap SS  <Plug>YSsurround

  " Original visual-mode mapping
  xmap S   <Plug>VSurround
  xmap gS  <Plug>VgSurround
endif
"}}}

" ======== delimitMate ======== {{{
function! s:init_delimitMate() abort
  imap <C-j> <PLug>delimitMateS-Tab
  smap <C-j> <PLug>delimitMateS-Tab
  imap <C-h> <BS>
endfunction
"}}}

" ======== smartchr ========"{{{
if IsInstalled('vim-smartchr')
  inoremap <expr> , smartchr#loop(', ', ',')

  " ======== python ========
  function! s:init_smartchr_py() abort
    inoremap <buffer><expr> = smartchr#loop(' = ', '=', ' == ', '==')
  endfunction

  " ======== javascript ========
  function! s:init_smartchr_js() abort
    inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
    inoremap <buffer> <expr> : smartchr#loop(': ', ':')
  endfunction

  augroup myvimrc
    autocmd FileType python call s:init_smartchr_py()
    autocmd FileType javascript call s:init_smartchr_js()
  augroup END
endif
"}}}

" ======== TextObj-User ======== {{{
if IsInstalled('vim-textobj-user')
  if IsInstalled('textobj-wiw')
    " wiw (snake_case)
    xmap au <Plug>(textobj-wiw-a)
    omap au <Plug>(textobj-wiw-a)
    xmap iu <Plug>(textobj-wiw-i)
    omap iu <Plug>(textobj-wiw-i)
  endif

  call textobj#user#plugin('heredoc', {
          \ 'doc': {
          \   'select-a-function': 'textobj#heredoc#select_a',
          \     'select-a': "ah",
          \   'select-i-function': 'textobj#heredoc#select_i',
          \     'select-i': "ih",
          \  },
          \ })
endif
"}}}

" ======== Rainbow parentheses ======== {{{
if exists(':RainbowParenthesesActivate')
  function! s:rainbow_parenthesis_colors() abort
    highlight level16c guifg=#aaaaaa cterm=bold gui=bold
    highlight level15c guifg=#ffd700
    highlight level14c guifg=#ff97bf
    highlight level13c guifg=#ffb000
    highlight level12c guifg=#00afff
    highlight level11c guifg=#afff00
    highlight level10c guifg=#d7875f
    highlight level9c  guifg=#ff0000
    highlight level8c  guifg=#aaaaaa
    highlight level7c  guifg=#ffd700
    highlight level6c  guifg=#ff97bf
    highlight level5c  guifg=#ffb000
    highlight level4c  guifg=#00afff
    highlight level3c  guifg=#afff00
    highlight level2c  guifg=#d7875f
    highlight level1c  guifg=#ff0000
  endfunction
  "}}}

  function! g:RainbowParenthesesStart()
    if !exists(':RainbowParenthesesToggleAll') ||
          \ count(get(g:, 'rainbow_parentheses_disable_filetypes', []), &filetype)
      return
    endif
    call s:rainbow_parenthesis_colors()
    RainbowParenthesesLoadRound
    RainbowParenthesesLoadSquare
    RainbowParenthesesLoadBraces
    " exec 'RainbowParenthesesLoadChevrons'
    call rainbow_parentheses#activate()
  endfunction

  autocmd myvimrc ColorScheme,Syntax * call g:RainbowParenthesesStart()
  nnoremap [Space]r :<C-u>RainbowParenthesesToggleAll<CR>
endif

"}}}

" ======== Indent-guides ======== {{{
if get(g:, 'loaded_indent_guides')
  nmap <silent> [Space]ig <Plug>IndentGuidesToggle

  if get(g:, 'indent_guides_enable_on_vim_startup')
    IndentGuidesEnable
  endif

  function! IndentGuidesColorAuto()
    let g:indent_guides_auto_colors = 1
    let g:indent_guides_color = 'auto'
    call indent_guides#toggle()
    call indent_guides#toggle()
  endfunction
  function! IndentGuidesColorLight()
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_color = 'light'
    hi IndentGuidesOdd  guibg=grey98 ctermbg=232
    hi IndentGuidesEven guibg=grey91 ctermbg=234
  endfunction
  function! IndentGuidesColorDark()
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_color = 'dark'
    hi IndentGuidesOdd   guibg=grey8  ctermbg=234
    hi IndentGuidesEven  guibg=grey11 ctermbg=235
  endfunction

  command! IndentGuidesColorAuto call IndentGuidesColorAuto()
  command! IndentGuidesColorLight call IndentGuidesColorLight()
  command! IndentGuidesColorDark call IndentGuidesColorDark()

  function! g:IndentGuidesExpandTab()
    if g:indent_guides_autocmds_enabled
      let guide_empty = exists('w:indent_guides_matches') ? empty(w:indent_guides_matches) : 0
      if &expandtab && guide_empty
        call indent_guides#enable()
      elseif !&expandtab && !guide_empty
        call indent_guides#disable()
      endif
    endif
  endfunction
  autocmd myvimrc FileType * nested call g:IndentGuidesExpandTab()

  function! g:IndentGuidesUpdateColorcheme()
    if g:indent_guides_autocmds_enabled
      if g:indent_guides_color ==# 'auto'
        call g:IndentGuidesColorAuto()
      elseif get(g:, 'colors_name') ==# 'caffe'
        hi IndentGuidesOdd ctermbg=233
        hi IndentGuidesEven ctermbg=234
      elseif &background ==# 'light'
        call g:IndentGuidesColorLight()
      else
        call g:IndentGuidesColorDark()
      endif
    endif
  endfunction
  autocmd myvimrc ColorScheme,Syntax * nested call g:IndentGuidesUpdateColorcheme()
endif
"}}}

" ======== vimquickrun ======== {{{
if get(g:, 'loaded_quickrun')
  map <Leader>r <Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
endif
"}}}

" ======== watchdogs ======== {{{
" Enable config
if get(g:, 'loaded_watchdogs')
  if exists('g:quickrun_config')
    call watchdogs#setup(g:quickrun_config)
  endif
endif
"}}}

" ======== LightLine ======== {{{
"}}}

" ======== cursorword ========"{{{
if get(g:, 'loaded_cursorword')
  highlight CursorWord0 term=underline cterm=underline gui=underline
endif
"}}}

" ======== Python ========{{{
function! s:init_python_plugin() abort
  if get(b:, 'loaded_init_python_plugin')
    return
  endif
  let b:loaded_init_python_plugin = 1

  if match(expand('%:t'), 'test_') == 0
    if exists(':QuickRun')
      noremap <buffer> <Leader>r :QuickRun pytest<CR>
    endif
    nnoremap <buffer> <Leader>p :!py.test -s -v %<CR>
  else
    nnoremap <buffer> <Leader>p :!python %<CR>
  endif

  " ======== Jedi-vim ========
  if !get(s:, 'init_jedi_done')
    let s:loaded_jedi = 0
    function! s:load_jedi() abort
      packadd jedi-vim
      let s:loaded_jedi = 1
    endfunction

    function! s:jedi_rename() abort
      if !s:loaded_jedi | call s:load_jedi() | endif
      call jedi#rename()
    endfunction
    function! s:jedi_usages()
      if !s:loaded_jedi | call s:load_jedi() | endif
      call jedi#usages()
      if len(getqflist()) < 10 && &filetype ==# 'qf'
        resize 10
      endif
    endfunction
    function! s:jedi_goto_a()
      if !s:loaded_jedi | call s:load_jedi() | endif
      call jedi#goto_assignments()
    endfunction
    function! s:jedi_doto_d()
      if !s:loaded_jedi | call s:load_jedi() | endif
      call jedi#goto_definitions()
    endfunction
    function! s:jedi_doc()
      if !s:loaded_jedi | call s:load_jedi() | endif
      call jedi#show_documentation()
    endfunction
    command! JediRename call <SID>jedi_rename()
    let s:init_jedi_done = 1
  endif
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

  " ======== watchdogs ========
  " if exists(':WatchdogsRun')
  "   autocmd myvimrc InsertLeave <buffer> WatchdogsRun
  " endif

  " ======== CoveragePy ========
  if exists(':Coveragepy')
    nnoremap <buffer> <leader>cr :<C-u>Coveragepy refresh<CR>
    nnoremap <buffer> <leader>cc :<C-u>Coveragepy show<CR>
    nnoremap <buffer> <leader>cs :<C-u>Coveragepy session<CR>
    nnoremap <buffer> <leader>cp :<C-u>CoveragepyPragmaToggle<CR>
  endif

endfunction

autocmd myvimrc FileType python call s:init_python_plugin()
"}}}

" ======== JavaScript ========"{{{
function! s:init_js_plugin() abort
  if get(b:, 'loaded_init_js_plugin')
    return
  endif
  let b:loaded_init_js_plugin = 1

  " ======== jscomplete ========
  if IsInstalled('jscomplete-vim')
    autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
  endif

endfunction

autocmd myvimrc FileType javascript,json,jsx,js call s:init_js_plugin()
"}}}

" ============================================
"  My Plugin Settings  {{{
" ============================================

" ======== conoline.vim ======== {{{
if get(g:, 'loaded_conoline')
  nnoremap [Space]sc :<C-u>ConoLineToggle<CR>
        \ :<C-u>echo conoline#status() ?
        \ 'ConoLine Enable' : 'ConoLine Disable'<CR>
endif
"}}}

" ======== SidePanel.vim ======== {{{
if get(g:, 'loaded_sidepanel')
  nnoremap <silent> [Space]e :<C-u>SidePanel vimfiler<CR>
  nnoremap <silent> [Space]t :<C-u>SidePanel tagbar<CR>
  " nnoremap <silent> [Space]g :<C-u>SidePanel gundo<CR>
  " nnoremap <silent> [Space]b :<C-u>SidePanel buffergator<CR>
  nnoremap <silent> [Space]l :<C-u>SidePanel<CR>
  nnoremap <silent> [Space]q :<C-u>SidePanelClose<CR>
  nnoremap <silent> [Space]p :<C-u>SidePanelPosToggle<CR>
  " nnoremap <silent> <F4> :<C-u>SidePanel buffergator<CR>
endif
"}}}

" ======== AsynCheck ========"{{{
if exists(':AsynCheck')
  autocmd myvimrc InsertLeave,BufWritePost *.py,*.js AsynCheck
  nnoremap <silent> <Leader><Leader> :<C-u>AsynCheck<CR>
endif
"}}}
"}}}

" ============================================
"  Lazy Load Packages"{{{
" ============================================

function! s:load_lazy_insert() abort
  autocmd! lazy_load_i
  if !exists(':packadd') | return | endif

  packadd vim-abolish
  packadd delimitMate
  call s:init_abolish()
  call s:init_delimitMate()
endfunction

augroup lazy_load_i
  autocmd! InsertEnter * call s:load_lazy_insert()
augroup END
"}}}

" ============================================
"  Post Process"{{{
" ============================================
" ======== execute auto commands ========
execute 'doautocmd myvimrc FileType ' . &filetype
doautocmd Syntax
"}}}
