" ============================================
"  Settings using plugin
" ============================================

" ======== ColorScheme ========
" Enable colorscheme
function! s:enable_colorscheme(...) abort
  if !&termguicolors && exists(':SeiyaEnable')
    SeiyaEnable
  endif
  syntax enable
  if has_key(g:, 'MyColorScheme')
    execute 'colorscheme ' . g:MyColorScheme
  endif
endfunction

" ============================================
"  Plugin settings {{{
" ============================================

" ======== Denite ======== {{{
if get(g:, 'loaded_denite')
  " denite prefix key
  nnoremap [denite] <Nop>
  nmap <Leader>f [denite]
  autocmd myvimrc FileType denite nmap <buffer><silent><nowait> q <PLUG>(denite_exit)

  " ======== Denite Key binding ========
  nnoremap <silent> [denite]u :<C-u>Denite
  nnoremap <silent> [denite]f :<C-u>Denite file/rec<CR>
  nnoremap <silent> [denite]b :<C-u>Denite buffer<CR>
  nnoremap <silent> [denite]m :<C-u>Denite file_mru<CR>
  nnoremap <silent> [denite]t :<C-u>Denite outline<CR>
  nnoremap <silent> [denite]c :<C-u>Denite change<CR>
  nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
  nnoremap <silent> [denite]w :<C-u>DeniteCursorWord grep line<CR>

  call denite#custom#option('default', {
        \ 'mode': 'normal',
        \ 'prompt': '>>>',
        \ })
  call denite#custom#map('insert', "<C-n>", '<denite:move_to_next_line>')
  call denite#custom#map('insert', "<C-p>", '<denite:move_to_previous_line>')

  " For file search
  call denite#custom#source('file/rec', 'matchers', ['matcher/regexp'])
  if executable('fd')
    " use fd
    call denite#custom#var('file/rec', 'command', ['fd', ''])
  elseif executable('rg')
    " use ripgrep
    call denite#custom#var('file/rec', 'command',
          \ ['rg', '--files', '--glob', '!.git'])
  elseif executable('ag')
    " use the_silver_searcher
    call denite#custom#var('file/rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  endif

  " For grep
  if executable('rg')
    " use ripgrep
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  elseif executable('ag')
    " use the_silver_searcher
    call denite#custom#var('grep', 'command', ['ag'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  endif
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
  if &filetype ==? 'vimfiler'
    call s:vimfiler_init()
  endif
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

" ======== Deoplete ======== {{{
if get(g:, 'loaded_deoplete')
  " ======== Key mappings ========
  inoremap <expr> <C-x><C-f> g:deoplete#manual_complete('file')

  " Close popup and save indent by <CR>
  inoremap <silent><expr> <CR> MyNeocomCR()
  function! MyNeocomCR()
    let l:delimitMateCR = delimitMate#ExpandReturn()
    return deoplete#close_popup() . l:delimitMateCR
  endfunction
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

" ======== Abolish ======== {{{
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
endfunction
"}}}

" ======== smartchr ======== {{{
if IsInstalled('vim-smartchr')
  inoremap <expr> , smartchr#loop(', ', ',')
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
  function! g:RainbowParenthesesStart(...)
    if !exists(':RainbowParenthesesToggleAll') ||
          \ count(get(g:, 'rainbow_parentheses_disable_filetypes', []), &filetype)
      return
    endif
    RainbowParenthesesLoadRound
    RainbowParenthesesLoadSquare
    RainbowParenthesesLoadBraces
    " exec 'RainbowParenthesesLoadChevrons'
    call rainbow_parentheses#activate()
  endfunction

  autocmd myvimrc ColorScheme,Syntax,BufRead * call g:RainbowParenthesesStart()
  nnoremap [Space]r :<C-u>RainbowParenthesesToggleAll<CR>
endif

"}}}

" ======== vimquickrun ======== {{{
if get(g:, 'loaded_quickrun')
  map <Leader>r <Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
endif
"}}}

" ======== vim-test ========{{{
if get(g:, 'loaded_test')
  noremap <silent> <Leader>t :<C-u>TestNearest<CR>
endif
"}}}

" ======== cursorword ======== {{{
if get(g:, 'loaded_cursorword')
  highlight CursorWord0 term=underline cterm=underline gui=underline
endif
"}}}
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

" ======== AsynCheck ======== {{{
if exists(':AsynCheck')
  function! s:enable_asyncheck() abort
    augroup autoasyncheck
      autocmd InsertLeave,BufWritePost <buffer> AsynCheck
    augroup END
  endfunction
  function! s:disable_asyncheck() abort
    augroup autoasyncheck
      autocmd!
    augroup END
  endfunction
  command! AsynCheckEnable call s:enable_asyncheck()
  command! AsynCheckDisable call s:disable_asyncheck()
  autocmd myvimrc FileType python,javascript,vim AsynCheckEnable
  nnoremap <Leader><Leader> :<C-u>AsynCheck<CR>
endif
"}}}

" ======== LiveMark ======== {{{
if exists(':LiveMarkBrowserMode')
  autocmd myvimrc FileType markdown nnoremap <buffer><nowait> <C-g> :LiveMarkBrowserMode<CR>
  if &filetype ==? 'markdown'
    nnoremap <buffer><nowait> <C-g> :LiveMarkBrowserMode<CR>
  endif
endif
"}}}

"}}}

" ============================================
"  Lazy Load Packages {{{
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
"  Post Process {{{
" ============================================
call s:enable_colorscheme()
if exists(':RainbowParenthesesActivate')
  call g:RainbowParenthesesStart()
endif
"}}}
