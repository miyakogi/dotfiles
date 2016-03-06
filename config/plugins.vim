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

" ======== Unite ======== {{{
if get(g:, 'loaded_unite', 0)
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

  function! MyUniteQfix()
    let qbuf = unite#helper#get_unite_bufnr('quickfix')
    let cmd = 'Unite quickfix location_list -no-quit -winheight=10 -buffer-name=quickfix -no-empty'
    if qbuf == -1
      execute cmd
    else
      execute 'UniteClose quickfix'
      execute cmd
    endif
  endfunction
  nnoremap <silent> [unite]q :<C-u>call MyUniteQfix()<CR>
endif

"}}}

" ======== VimFiler ========"{{{
if get(g:, 'loaded_vimfiler', 0)
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
if get(g:, 'loaded_signify', 0)
  autocmd myvimrc ColorScheme,Syntax * highlight link SignifySignAdd LineNr
                            \ | highlight link SignifySignChange PreProc
                            \ | highlight SignifySignDelete guifg=#EE3333 ctermfg=red
endif
"}}}

" ======== anzu ======== {{{
if get(g:, 'loaded_anzu', 0)
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
if get(g:, 'loaded_anzu', 0)
  xmap * <Plug>(visualstar-*)
  xmap g* <Plug>(visualstar-g*)
  xmap # <Plug>(visualstar-#)
  xmap g# <Plug>(visualstar-g#)
endif
"}}}

" ======== NeoComplete ======== {{{
function! s:init_neocomplete() abort
  if get(g:, 'loaded_neocomplete', 0)
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

    " Enable omni completion.
    augroup myvimrc
      autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
      autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
      " autocmd FileType nim setlocal omnifunc=NimComplete
      autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    augroup END

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
    " let g:neocomplete#sources#omni#input_patterns.nim = '[^. *\t]\.\w*'
  endif
endfunction
"}}}

" ======== NeoSnippets ======== {{{
function! s:init_neosnippets() abort
  if get(g:, 'loaded_neosnippet', 0)
    imap <C-Space> <Plug>(neosnippet_expand_or_jump)
    smap <C-Space> <Plug>(neosnippet_expand_or_jump)
    " For snippet_complete marker.
    " if has('conceal')
    "   set conceallevel=2 concealcursor=i
    " endif
  endif
endfunction
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
if get(g:, 'loaded_tcomment', 0)
  nnoremap gcl      :TCommentRight<CR>
  nnoremap gcp      vip:TCommentBlock<CR>
  xnoremap gb       :TCommentBlock<CR>
  xnoremap gi       :TCommentInline<CR>
  imap     <C-g>c   <C-o>:TComment<CR>
  imap     <C-g>l   <C-o>:TCommentRight<CR>
endif
"}}}

" ======== surround.vim ======== {{{
if get(g:, 'loaded_surround', 0)
  " Original mapping
  autocmd myvimrc BufNew,BufReadPost,BufNewFile * call DSurroundMap()
  function! DSurroundMap()
    if &buftype !=# ''
      nmap ds  <Plug>Dsurround
    endif
  endfunction
  " nmap ds  <Plug>Dsurround
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
function! s:init_smartchr()
  if IsInstalled('vim-smartchr')
    inoremap <expr> , smartchr#loop(', ', ',')

    function! g:GetPrevChar() abort
      let l:col = getcurpos()[2]
      let l:line = getline('.')
      if len(l:line) < 2
        return ''
      endif
      return l:line[l:col - 2]
    endfunction

    function! g:IsAfterSpace() abort
      let l:prv_chr = g:GetPrevChar()
      if l:prv_chr ==# ' '
        return 1
      else
        return 0
      endif
    endfunction

    augroup myvimrc
      " ======== python ========
      autocmd FileType python,pytest inoremap <buffer><expr> = smartchr#loop(' = ', '=', ' == ', '==')
      autocmd FileType python,pytest inoremap <buffer><expr> + smartchr#loop(' + ', '+', ' += ')
      autocmd FileType python,pytest inoremap <buffer><expr> - smartchr#loop(' - ', '-', ' -= ')
      autocmd FileType python,pytest inoremap <buffer><expr> * smartchr#loop(' * ', '*', ' ** ', '**')
      autocmd FileType python,pytest inoremap <buffer><expr> <C-L> smartchr#loop(' -> ', '->')

      " ======== javascript ========
      autocmd FileType javascript inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' == ', ' === ')
      autocmd FileType javascript inoremap <buffer> <expr> + smartchr#loop(' + ', '+')
      autocmd FileType javascript inoremap <buffer> <expr> - smartchr#loop(' - ', '-', '--')
      autocmd FileType javascript inoremap <buffer> <expr> * smartchr#loop(' * ', '*')
      autocmd FileType javascript inoremap <buffer> <expr> , smartchr#loop(', ', ',')
      autocmd FileType javascript inoremap <buffer> <expr> : smartchr#loop(': ', ':')
    augroup END
  endif
endfunction
"}}}

" ======== TextObj-User ======== {{{
if IsInstalled('vim-textobj-user')
  runtime! plugin/textobj/*.vim
  if IsInstalled('textobj-wiw')
    " wiw (snake_case)
    xmap a_ <Plug>(textobj-wiw-a)
    omap a_ <Plug>(textobj-wiw-a)
    xmap i_ <Plug>(textobj-wiw-i)
    omap i_ <Plug>(textobj-wiw-i)
    xmap au <Plug>(textobj-wiw-a)
    omap au <Plug>(textobj-wiw-a)
    xmap iu <Plug>(textobj-wiw-i)
    omap iu <Plug>(textobj-wiw-i)
  endif

  " ======== snigel/double quote in multi-line ========
  function! SelectHereDoc(start, end, inner)
    let current_pos = getpos('.')
    let found_start = search(a:start, a:inner ? 'bce' : 'bc')

    " quote not found. go back cursol.
    if found_start == 0
      call setpos('.', current_pos)
      return 0
    endif

    if a:inner
      " execute "normal! \<Right>"
      call search('\S')
      let start_pos = getpos('.')
    else
      let start_pos = getpos('.')
      call search(a:start, 'ce')
      execute "normal! \<Right>"
    endif

    let found_end = search(a:end, a:inner ? 'c' : 'ce')
    if found_end == 0
      call setpos('.', current_pos)
      return 0
    endif

    if a:inner
      call search('\S', 'b')
    endif
    let end_pos = getpos('.')

    return ['v', start_pos, end_pos]
  endfunction

  function! SelectHereDocA()
    let start_pattern = get(b:, 'heredoc_start_pattern', 0)
    let end_pattern = get(b:, 'heredoc_end_pattern', 0)
    if (start_pattern ==# '' || end_pattern ==# '')
      return 0
    else
      return SelectHereDoc(start_pattern, end_pattern, 0)
    endif
  endfunction

  function! SelectHereDocI()
    let start_pattern = get(b:, 'heredoc_start_pattern', '')
    let end_pattern = get(b:, 'heredoc_end_pattern', '')
    if (start_pattern ==# '' || end_pattern ==# '')
      return 0
    else
      return SelectHereDoc(start_pattern, end_pattern, 1)
    endif
  endfunction

  augroup myvimrc
    autocmd FileType python,python.pytest let b:heredoc_start_pattern = '\v(''''''|""")'
    autocmd FileType python,python.pytest let b:heredoc_end_pattern = '\v(''''''|""")'
    autocmd FileType go let b:heredoc_start_pattern = '\v`'
    autocmd FileType go let b:heredoc_end_pattern = '\v`'
  augroup END

  call textobj#user#plugin('heredoc', {
          \ 'doc': {
          \   'select-a-function': 'SelectHereDocA',
          \     'select-a': "ah",
          \   'select-i-function': 'SelectHereDocI',
          \     'select-i': "ih",
          \  },
          \ })
endif
"}}}

" ======== Syntastic ======== {{{
if get(g:, 'loaded_syntastic', 0)
  let g:syntastic_enable_signs=1
  let g:syntastic_enable_balloons=0
  let g:syntastic_enable_highlighting=0
  let g:syntastic_auto_loc_list=0
  let g:syntastic_always_populate_loc_list=1
  let g:syntastic_loc_close_cmd = 'UniteClose quickfix'

  let g:syntastic_filetype_map = {
        \ 'python.nose': 'python',
        \ 'python.nose3': 'python',
        \ 'python.pytest': 'python',
        \ 'latex': 'tex',
        \ 'plaintex': 'tex'
        \ }
  let g:syntastic_mode_map = {'mode': 'passive',
        \ 'active_filetypes': [
        \   'sh', 'php', 'perl', 'ruby', 'c', 'cpp', 'javascript', 'coffee',
        \ ],
        \ 'passive_filetypes': [
        \   'python', 'latex', 'tex', 'vim', 'dart',
        \ ]
        \}
  if executable('gjslint')
    let g:syntastic_javascript_checkers = ['gjslint']
  endif
  if executable('coffeelint')
    let g:syntastic_coffee_checkers = ['coffeelint']
  endif
  if executable('pyflakes3')
    let g:syntastic_python_checkers = ['pyflakes3']
  elseif executable('pyflakes')
    let g:syntastic_python_checkers = ['pyflakes']
  else
    let g:syntastic_python_checkers = ['pylint']
  endif
  if executable('mypy')
    let g:syntastic_python_checkers += ['mypy']
  endif

  autocmd myvimrc ColorScheme,Syntax * hi SyntasticErrorSign ctermfg=red ctermbg=234 guifg=#f03300 guibg=grey8 gui=bold
endif
"}}}

" ======== Rainbow parentheses ======== {{{
if exists(':RainbowParenthesesActivate')
  " From badwolf.vim colorscheme {{{
  "
  " Copyright (C) 2012 Steve Losh and Contributors
  "
  " Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  "
  " The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  "
  " THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  " Pallet {{{
  let s:bwc = {}

  " The most basic of all our colors is a slightly tweaked version of the Molokai
  " Normal text.
  let s:bwc.plain = ['f8f6f2', 15]

  " Pure and simple.
  let s:bwc.snow = ['ffffff', 15]
  let s:bwc.coal = ['000000', 16]

  " All of the Gravel colors are based on a brown from Clouds Midnight.
  let s:bwc.brightgravel   = ['d9cec3', 252]
  let s:bwc.lightgravel    = ['998f84', 245]
  let s:bwc.gravel         = ['857f78', 243]
  let s:bwc.mediumgravel   = ['666462', 241]
  let s:bwc.deepgravel     = ['45413b', 238]
  let s:bwc.deepergravel   = ['35322d', 236]
  let s:bwc.darkgravel     = ['242321', 235]
  let s:bwc.blackgravel    = ['1c1b1a', 233]
  let s:bwc.blackestgravel = ['141413', 232]

  " A color sampled from a highlight in a photo of a glass of Dale's Pale Ale on
  " my desk.
  let s:bwc.dalespale = ['fade3e', 221]

  " A beautiful tan from Tomorrow Night.
  let s:bwc.dirtyblonde = ['f4cf86', 222]

  " Delicious, chewy red from Made of Code for the poppiest highlights.
  let s:bwc.taffy = ['ff2c4b', 196]

  " Another chewy accent, but use sparingly!
  let s:bwc.saltwatertaffy = ['8cffba', 121]

  " The star of the show comes straight from Made of Code.
  let s:bwc.tardis = ['0a9dff', 39]

  " This one's from Mustang, not Florida!
  let s:bwc.orange = ['ffa724', 214]

  " A limier green from Getafe.
  let s:bwc.lime = ['aeee00', 154]

  " Rose's dress in The Idiot's Lantern.
  let s:bwc.dress = ['ff9eb8', 211]

  " Another play on the brown from Clouds Midnight.  I love that color.
  let s:bwc.toffee = ['b88853', 137]

  " Also based on that Clouds Midnight brown.
  let s:bwc.coffee    = ['c7915b', 173]
  let s:bwc.darkroast = ['88633f', 95]
  "}}}

  function! s:HL(group, fg, ...)
    " Arguments: group, guifg, guibg, gui, guisp

    let histring = 'hi ' . a:group . ' '

    if strlen(a:fg)
      if a:fg ==# 'fg'
        let histring .= 'guifg=fg ctermfg=fg '
      else
        let c = get(s:bwc, a:fg)
        let histring .= 'guifg=#' . c[0] . ' ctermfg=' . c[1] . ' '
      endif
    endif

    if a:0 >= 1 && strlen(a:1)
      if a:1 ==# 'bg'
        let histring .= 'guibg=bg ctermbg=bg '
      else
        let c = get(s:bwc, a:1)
        let histring .= 'guibg=#' . c[0] . ' ctermbg=' . c[1] . ' '
      endif
    endif

    if a:0 >= 2 && strlen(a:2)
      let histring .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
    endif

    if a:0 >= 3 && strlen(a:3)
      let c = get(s:bwc, a:3)
      let histring .= 'guisp=#' . c[0] . ' '
    endif

    execute histring
  endfunction

  function! s:rainbow_parenthesis_badwolf() abort
    call s:HL('level16c', 'mediumgravel',   '', 'bold')
    call s:HL('level15c', 'dalespale',      '', '')
    call s:HL('level14c', 'dress',          '', '')
    call s:HL('level13c', 'orange',         '', '')
    call s:HL('level12c', 'tardis',         '', '')
    call s:HL('level11c', 'lime',           '', '')
    call s:HL('level10c', 'toffee',         '', '')
    call s:HL('level9c',  'saltwatertaffy', '', '')
    call s:HL('level8c',  'coffee',         '', '')
    call s:HL('level7c',  'dalespale',      '', '')
    call s:HL('level6c',  'dress',          '', '')
    call s:HL('level5c',  'orange',         '', '')
    call s:HL('level4c',  'tardis',         '', '')
    call s:HL('level3c',  'lime',           '', '')
    call s:HL('level2c',  'toffee',         '', '')
    call s:HL('level1c',  'saltwatertaffy', '', '')
  endfunction
  "}}}

  function! g:RainbowParenthesesStart()
    if !exists(':RainbowParenthesesToggleAll') ||
          \ count(g:rainbow_parentheses_disable_filetypes, &filetype)
      return
    endif
    RainbowParenthesesLoadRound
    RainbowParenthesesLoadSquare
    RainbowParenthesesLoadBraces
    " exec 'RainbowParenthesesLoadChevrons'
    call rainbow_parentheses#activate()
    call s:rainbow_parenthesis_badwolf()
  endfunction

  autocmd myvimrc ColorScheme,FileType,Syntax * nested call g:RainbowParenthesesStart()
  autocmd MyVimEnter BufEnter * nested call g:RainbowParenthesesStart()
  nnoremap [Space]r :<C-u>RainbowParenthesesToggleAll<CR>
endif

"}}}

" ======== Indent-guides ======== {{{
if get(g:, 'loaded_indent_guides', 0)
  nmap <silent> [Space]ig <Plug>IndentGuidesToggle

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
      elseif g:indent_guides_color ==# 'light'
        call g:IndentGuidesColorLight()
      else
        call g:IndentGuidesColorDark()
      endif
    endif
  endfunction
  autocmd myvimrc ColorScheme,Syntax * nested call g:IndentGuidesUpdateColorcheme()

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
endif
"}}}

" ======== vimquickrun ======== {{{
if get(g:, 'loaded_quickrun', 0)
  " NeoBundleLazy fails with mappings:<leader>r
  map <Leader>r <Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
endif

" Enable config
if get(g:, 'loaded_watchdogs', 0)
  call watchdogs#setup(g:quickrun_config)
  " augroup myvimrc
  "   autocmd BufRead,BufNewFile *.py,*.js,*.coffee execute 'WatchdogsRun'
  "         \ | xnoremap <buffer><silent> x x:WatchdogsRun<CR><left>
  "         \ | xnoremap <buffer><silent> d d:WatchdogsRun<CR><left>
  "         \ | xnoremap <buffer><silent> D D:WatchdogsRun<CR><left>
  "         \ | nnoremap <buffer><silent> D D:WatchdogsRun<CR><left>
  "         \ | nnoremap <buffer><silent> dd dd:WatchdogsRun<CR><left>
  "         \ | nnoremap <buffer><silent> dw dw:WatchdogsRun<CR><left>
  "         \ | nnoremap <buffer><silent> u u:WatchdogsRun<CR><left>
  "         \ | nnoremap <buffer><silent> <C-R> <C-R>:WatchdogsRun<CR><left>
  "         \ | inoremap <buffer><silent> <Esc> <Esc>:WatchdogsRun<CR>
  " augroup END
endif
"}}}

" ======== LightLine ======== {{{
if get(g:, 'loaded_lightline', 0)
  let g:lightline_conf = $HOME . '/.vim/config/lightline_conf.vim'
  if filereadable(g:lightline_conf)
    execute 'source ' . g:lightline_conf
  endif
endif
"}}}

" ======== cursorword ========"{{{
if get(g:, 'loaded_cursorword', 0)
  highlight CursorWord0 term=underline cterm=underline gui=underline
endif
"}}}

" ======== Jedi-vim ======== {{{
if exists(':JediDebugInfo')
  command! JediRename call jedi#rename()
  nnoremap <buffer> gl :<C-u>call <SID>jedi_usages()<CR>
  setlocal omnifunc=jedi#completions

  if has('python') && !get(g:, 'loaded_myjedi')
    let g:loaded_myjedi = 1
    function! s:jedi_usages()
      " call jedi#usages()
      let nodefs = 0
      if exists(':Python')
        " From jedi_vim.goto()
        python <<EOF
import jedi_vim
import vim

definitions = jedi_vim.goto(is_related_name=True, no_output=True)
if definitions:
    lst = []
    for d in definitions:
        if d.in_builtin_module():
            lst.append(dict(text=jedi_vim.PythonToVimStr('Builtin ' + d.description)))
        else:
            lst.append(dict(filename=jedi_vim.PythonToVimStr(d.module_path),
                            lnum=d.line, col=d.column + 1,
                            text=jedi_vim.PythonToVimStr(d.description)))
    jedi_vim.vim_eval('setqflist(%s)' % repr(lst))
else:
    vim.command('let l:nodefs = 1')
EOF
        if l:nodefs
          execute 'UniteClose quickfix'
        else
          call MyUniteQfix()
        endif
      endif
    endfunction
  endif
endif

" ======== CoveragePy ========
if exists(':Coveragepy')
  nnoremap <buffer> <leader>cr :<C-u>Coveragepy refresh<CR>
  nnoremap <buffer> <leader>cc :<C-u>Coveragepy show<CR>
  nnoremap <buffer> <leader>cs :<C-u>Coveragepy session<CR>
  nnoremap <buffer> <leader>cp :<C-u>CoveragepyPragmaToggle<CR>
endif

" ======== mccabepy ========
if exists(':MccabePy')
  nnoremap <buffer> <leader>mc :<C-u>MccabePy<CR>
endif

"}}}

" ========= vim-flake8 ======== {{{
if exists(':Unite')
  let g:flake8_loc_open_cmd = 'Unite location_list -no-quit' .
        \ ' -winheight=10 -buffer-name=pep8'
  let g:flake8_loc_close_cmd = 'UniteClose pep8'
endif
if exists(':Flake8')
  nnoremap <F7> :<C-u>Flake8<CR>
endif
"}}}

" }}}

" ============================================
"  My Plugin Settings  {{{
" ============================================

" ======== conoline.vim ======== {{{
if get(g:, 'loaded_conoline', 0)
  nnoremap [Space]sc :<C-u>ConoLineToggle<CR>
        \ :<C-u>echo conoline#status() ?
        \ 'ConoLine Enable' : 'ConoLine Disable'<CR>
endif
"}}}

" ======== SidePanel.vim ======== {{{
if get(g:, 'loaded_sidepanel', 0)
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

"}}}


" ============================================
"  Lazy Load Packages
" ============================================

function! s:load_lazy_insert() abort
  packadd abolish
  packadd delimitMate
  packadd neocomplete.vim
  packadd neosnippet
  packadd neosnippet-snippets
  packadd vim-smartchr

  call s:init_abolish()
  call s:init_delimitMate()
  call s:init_neocomplete()
  call s:init_neosnippets()
  call s:init_smartchr()
  autocmd! lazy_load_i
endfunction

augroup lazy_load_i
  autocmd! InsertEnter * call s:load_lazy_insert()
augroup END
