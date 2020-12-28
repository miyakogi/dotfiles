" ============================================
"  Settings using plugin
" ============================================

" ======== ColorScheme ========
" Enable colorscheme
function! s:enable_colorscheme(...) abort

  if has_key(g:, 'MyColorScheme')
    set background=dark
    execute 'colorscheme ' . g:MyColorScheme
    if g:MyColorScheme ==# 'pencil'
      " change colors for GitGutter
      highlight GitGutterAdd    guifg=#009900 ctermfg=2
      highlight GitGutterChange guifg=#bbbb00 ctermfg=3
      highlight GitGutterDelete guifg=#ff2222 ctermfg=1
    end
  endif
  syntax enable

  if get(g:, 'loaded_lightline')
    call lightline#enable()
  endif
  if exists(':SeiyaEnable') && !has('gui_running') && !(has('win32') || has('win64'))
    SeiyaEnable
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

  " ======== Denite Key binding ========
  nnoremap <silent> [denite]f :<C-u>Denite file/rec<CR>
  nnoremap <silent> [denite]b :<C-u>Denite buffer<CR>
  nnoremap <silent> [denite]m :<C-u>Denite file_mru<CR>
  nnoremap <silent> [denite]t :<C-u>Denite outline<CR>
  nnoremap <silent> [denite]c :<C-u>Denite change<CR>
  nnoremap <silent> [denite]g :<C-u>Denite grep<CR>
  nnoremap <silent> [denite]w :<C-u>DeniteCursorWord grep line<CR>

  " Key binding for denite buffer
  autocmd myvimrc FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> t denite#do_map('do_action', 'tabswitch')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
  endfunction

  call denite#custom#option('default', {
        \ 'mode': 'normal',
        \ 'prompt': '>>>',
        \ })
  call denite#custom#map('insert', "<C-n>", '<denite:move_to_next_line>')
  call denite#custom#map('insert', "<C-p>", '<denite:move_to_previous_line>')

  " For lightline, disable denite's statusline
  if get(g:, 'loaded_lightline')
    call denite#custom#option('default', 'statusline', v:false)
  endif

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

" ======== Defx ======== {{{
if get(g:, 'loaded_defx')
	autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
	  nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
	  nnoremap <silent><buffer><expr> mc defx#do_action('copy')
	  nnoremap <silent><buffer><expr> mm defx#do_action('move')
	  " nnoremap <silent><buffer><expr> p  defx#do_action('paste')
	  nnoremap <silent><buffer><expr> l defx#do_action('open')
	  nnoremap <silent><buffer><expr> t defx#do_action('drop', 'tabnew')
	  " nnoremap <silent><buffer><expr> E defx#do_action('open', 'vsplit')
	  " nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
	  nnoremap <silent><buffer><expr> mA defx#do_action('new_directory')
	  nnoremap <silent><buffer><expr> ma defx#do_action('new_file')
	  nnoremap <silent><buffer><expr> md defx#do_action('remove')
	  nnoremap <silent><buffer><expr> r defx#do_action('rename')
	  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
	  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
	  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> u defx#do_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> ~ defx#do_action('cd')
	  nnoremap <silent><buffer><expr> q defx#do_action('quit')
	  " nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
	  " nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
	  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
	  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
	  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
	endfunction

  nnoremap [Space]f :<C-u>Defx -split=tab<CR>
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
  nmap * <Plug>(anzu-star)
  nmap # <Plug>(anzu-sharp)
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

" ======== ale ======== {{{
if get(g:, 'loaded_ale')
  " update lightline after ale run
  if get(g:, 'loaded_lightline')
    autocmd myvimrc User ALELintPost call lightline#update()
  endif

  " jump to errors
  nmap <silent> ]e <Plug>(ale_next)
  nmap <silent> [e <Plug>(ale_previous)
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
  nnoremap <silent> [Space]e :<C-u>SidePanel defx<CR>
  nnoremap <silent> [Space]t :<C-u>SidePanel tagbar<CR>
  " nnoremap <silent> [Space]g :<C-u>SidePanel gundo<CR>
  " nnoremap <silent> [Space]b :<C-u>SidePanel buffergator<CR>
  nnoremap <silent> [Space]l :<C-u>SidePanel<CR>
  nnoremap <silent> [Space]q :<C-u>SidePanelClose<CR>
  nnoremap <silent> [Space]p :<C-u>SidePanelPosToggle<CR>
  " nnoremap <silent> <F4> :<C-u>SidePanel buffergator<CR>
endif
" }}}

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

" Load abolish in the startup (temporary bug)
packadd vim-abolish

function! s:load_lazy_insert() abort
  autocmd! lazy_load_i
  if !exists(':packadd') | return | endif

  " packadd vim-abolish
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
