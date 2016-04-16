set encoding=utf-8
scriptencoding utf-8
" if has('vim_starting') | set nocompatible | endif

" =========================================================
"     **** ViM Configuration for Linux and Windows ****
" =========================================================

" ======== encoding ======== {{{
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,iso-2022-jp,euc-jp,default,latin
set fileformats=unix,dos,mac
set shellslash  " Necessary for windows
"}}}

" ======== Startup ======== {{{
augroup myvimrc
  autocmd!
augroup END

" https://gist.github.com/1518874
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
endif
"}}}

" ======== Environment variables ========"{{{
if has('vim_starting')
  function! s:addpath_if_exists(path)
    let l:path = expand(a:path)
    let l:sep = has('win32') ? ';' : ':'
    if isdirectory(l:path) || filereadable(l:path)
      let $PATH = l:path . l:sep . $PATH
    endif
  endfunction
endif
"}}}

" ============================================
"  Default Plugin Settings"{{{
" ============================================
" ======== disable default plugins ========
let g:loaded_gzip = 1
let g:loaded_LogiPat = 1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
let g:MyColorScheme = 'caffe'
"}}}

" ============================================
"  Set Filetypes{{{
" ============================================
" ======== detect filetypes ========
if filereadable(expand('~/.vim/config/filetype.vim'))
  source ~/.vim/config/filetype.vim
endif
filetype plugin indent on
"}}}

" ============================================
"  User setting start {{{
" ============================================

" ======== System setting ========
set autoread
autocmd myvimrc WinEnter * checktime

set backupdir=~/.vim/backup
set noundofile
set noswapfile
set hidden " Hide closed buffer
set wildmenu " Enable command extension in command mode
set wildmode=longest:full,full
" Enable selecting out-of-line region in blockwise-visual mode
set virtualedit+=block

autocmd myvimrc BufEnter * setlocal formatoptions-=o
autocmd myvimrc BufEnter * setlocal formatoptions-=r
" 前後がMulti−byte文字の時の行連結でスペース入れない
autocmd myvimrc BufEnter * setlocal formatoptions+=M
" コメント行の連結をいい感じにやってくれる
autocmd myvimrc BufEnter * setlocal formatoptions+=j

set nrformats-=octal
set nojoinspaces " Do not enter two spaces when join lines end with '.'.
" word区切り条件に # 追加
" autocmd myvimrc FileType vim setlocal iskeyword-=#
set textwidth=0 " 自動折り返しなし
set backspace=indent,eol,start " BSキーや<C-w>でインデント、改行削除
set wildignore&  " A file that matches with one of these patterns is ignored
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.bak,*.?~,*.??~,*.???~,*.~      " Backup files
set wildignore+=*.pyc                            " Python byte code

if !has('win32') && !has('mac')
  language en_US.UTF-8
endif
set keywordprg=:help
set helplang& helplang=en,ja

set notimeout
set ttimeout
set ttimeoutlen=50

set completeopt-=preview " Disable previewwindow in completion
set completeopt-=longest " Disable vim's longest match
set previewheight=10 " Maximum height of the preview window.
set pumheight=16 " Maximum height of pupup menu in completion
set diffopt=filler,vertical

set visualbell t_vb=
set noerrorbells

" ======== Mouse setting ========
set mouse=a
" set mousefocus
set mousehide
set mousemodel=popup

" ======== Display setting ========
set scrolloff=5 " カーソルの上下の最低行数
set sidescrolloff=5 " カーソルの左右の最低Column数
set display=lastline " show all line as poossible
set wrap " wrap long line.
set nonumber " show line number column
set showcmd " show some command in the end of cmd win
set report=2
set noruler
set nospell " Disable spell check
set spelllang+=cjk " Disable spell check on multibyte characters
set list " Display invisible chars
set listchars=tab:\|\ ,trail:_
set shiftround
set nolinebreak
let &showbreak = '↪ '
if v:version >= 704 && has('patch338')
  " let &showbreak = '↪  '
  set breakindent
  " set breakindentopt=shift:1
endif
set ambiwidth=single

" ======== Window setting ========
set cmdheight=1 " Hight of the cmdline
set splitbelow " Create new window below the current window.
set splitright " Create new window below the current window.
set noequalalways " When on, all windows are automatically made the same size after split/close

" ======== Folding setting ========
set foldmethod=marker
set foldtext=MyFoldText()

function! MyFoldText()
  let line = getline(v:foldstart)
  let marker_removed = substitute(line, '{{{\d*', '', 'g') " }}}
  let marker_removed = substitute(marker_removed, '^"', "\u21c9 ", 'g')
  let line_count = v:foldend - v:foldstart
  let lines = line_count > 1 ? ' lines' : ' line'
  let count_in_brace = substitute(marker_removed, '\s*$', ' ('.line_count.lines.') ', '')
  return count_in_brace
endfunction

" ======== Search setting ========
set ignorecase " Ignore cases in search patterns
set smartcase " When search pattern contains upper case chars, disable ignorecase
set incsearch " While typing a search pattern, highlight first match (if exists)
set hlsearch " Highlight all the patterns matched.
set history=10000 " Size of the history to save.
set nowrapscan " End the search at the end of file.

" ======== Tab and indent setting ========
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nocindent
set autoindent
set smartindent

" Restrict number of columns to highlight, to impove speed
set synmaxcol=360
set lazyredraw
"}}}

" ============================================
"  User Key Binding {{{
" ============================================

" ======== Base binding ========
nmap <Space> [Space]
nnoremap [Space] <NOP>

" ======== Cursor move ========
" カーソルキーで行末／行頭の移動可能に設定。
set whichwrap=b,s,<,>,[,]
" h,l で行末/行頭の移動可能
nnoremap h <Left>
nnoremap l <Right>
xnoremap h <Left>
xnoremap l <Right>

" Down and Up with display-lines
nnoremap <silent> j gj
nnoremap <silent> k gk
xnoremap <silent> j gj
xnoremap <silent> k gk
nnoremap <silent> gj j
nnoremap <silent> gk k
xnoremap <silent> gj j
xnoremap <silent> gk k

if has('win32')
  inoremap <silent> <UP> <C-o>k
  inoremap <silent> <DOWN> <C-o>j
elseif has('mac')
  inoremap <silent> <UP> <C-o>k
  inoremap <silent> <DOWN> <C-o>j
else
  function! FcitxUp()
    normal! k
    return ''
  endfunction
  function! FcitxDown()
    normal! j
    return ''
  endfunction
  inoremap <silent> <UP> <C-r>=FcitxUp()<CR>
  inoremap <silent> <DOWN> <C-r>=FcitxDown()<CR>
endif

" 行頭・行末への移動
noremap H ^
noremap L $

" l を <right>に置き換えて、折りたたみを l で開くことができるようにする。
if has('folding')
  nnoremap <expr><silent> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
endif

" 前後のカッコへの移動
noremap ) t)
noremap ( t(

" QuickFix windowを開く（エラーがあれば）
nnoremap [Space]c :<C-u>cwindow<CR>
" qflistの前後移動
nnoremap ]q :<C-u>cnext<CR>
nnoremap [q :<C-u>cprevious<CR>
" diffモードでの前後移動
nnoremap ]d ]c
nnoremap [d [c

" ======== Cursor move (Insert/Command mode) ========
inoremap <C-h> <BS>

" Don't move cursor at leaving insert mode
" inoremap <silent> <Esc>  <Esc>`^
" inoremap <silent> <C-[>  <Esc>`^
" autocmd myvimrc InsertLeave * normal! `^
" set t_kl=OD

" Emacs like keybinding in insert mode.
inoremap <C-a> <C-o>_
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
" Emacs like keybinding in cmd window.
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" cnoremap <C-f> <Right>
" cnoremap <C-b> <Left>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <Down> <C-n>
cnoremap <Up> <C-p>

" Better completion in cmdwin
" http://hujo.hateblo.jp/entry/2014/03/23/160512
set wildcharm=<TAB>
cnoremap <expr> <Tab> wildmenumode() ? "\<C-n>" : "\<Tab>"
cnoremap <expr> <S-Tab> wildmenumode() ? "\<C-p>" : ""

" Paren-completions using plaseholders
" let g:loaded_matchparen=1

" ======== textmanip ========
nnoremap <C-S-Up> :<C-u>move-2<CR>
nnoremap <C-S-Down> :<C-u>move+<CR>
inoremap <C-S-Up> <C-o>:<C-u>move-2<CR>
inoremap <C-S-Down> <C-o>:<C-u>move+<CR>

" ======== Window size control ========
" Window size
if has('gui_running')
  nnoremap <S-Up> <C-w>+
  nnoremap <S-Down> <C-w>-
  nnoremap <S-Right> <C-w>>
  nnoremap <S-Left> <C-w><
endif

" Key repeat hack for resizing splits, i.e., <C-w>+++- vs <C-w>+<C-w>+<C-w>-
" see: http://www.vim.org/scripts/script.php?script_id=2223
nmap + <C-w>+<SID>ws
nmap - <C-w>-<SID>ws
nmap <C-w>> <C-w>><SID>ws
nmap <C-w>< <C-w><<SID>ws
nnoremap <script> <SID>ws+ <C-w>+<SID>ws
nnoremap <script> <SID>ws- <C-w>-<SID>ws
nnoremap <script> <SID>ws> <C-w>><SID>ws
nnoremap <script> <SID>ws< <C-w><<SID>ws
nmap <SID>ws <Nop>

" ======== Tab setting ========
" Tab control
nnoremap <M-n> :<C-u>tabnew<CR>
nnoremap <Leader>n :<C-u>tabnew<CR>
nnoremap <M-c> :<C-u>tabclose<CR>
nnoremap <M-t> :<C-u>call g:MoveToNewTab()<CR>
nnoremap <M-Right> gt
nnoremap <M-Left> gT
nnoremap <C-j> gt
nnoremap <C-k> gT
nnoremap <C-Right> gt
nnoremap <C-Left> gT
nnoremap <S-Right> gt
nnoremap <S-Left> gT

function! g:MoveToNewTab()
  tab split
  tabprevious
  if winnr('$') > 1
    close
  elseif bufnr('$') > 1
    buffer #
  endif
  tabnext
endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  " let sep = '│'  " タブ間の区切り
  let sep = '|'  " タブ間の区切り
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  let info = ''  " 好きな情報を入れる
  let info .= '[' . fnamemodify(getcwd(), ':~') . ']'
  return '     ' . tabpages . '%=' . info " タブリストを左に、情報を右に表示
endfunction

" 各タブページのカレントバッファ名+αを表示
function! s:tabpage_label(n)
  " t:title と言う変数があったらそれを使う
  let title = gettabvar(a:n, 'title')
  if title !=# ''
    return title
  endif

  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " バッファが複数あったらバッファ数を表示
  let no = len(bufnrs)
  if no is 1
    let no = ''
  endif
  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
  let sp = (no . mod) ==# '' ? '' : ' '  " 隙間空ける

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = pathshorten(bufname(curbufnr))

  let label = no . mod . sp . fname

  return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction

" タブページを常に表示
set showtabline=2
" gVimでもテキストベースのタブページを使う
" set guioptions-=e
set guioptions=
set tabline=%!MakeTabLine()

" ======== Tips ========
" 実践Vim（らしい
xnoremap . :normal .<CR>
" Q でExモードに入らずコマンドモードに入る
nnoremap Q q:i

" 最後の置換を同じフラグで繰り返す。フラグを変えたい時は :& [flags]
nnoremap & :&&<CR>
vnoremap & :&&<CR>

" MacVimでLeader
if has('mac')
  map _ <Leader>
endif

"<C-[>での<C-@>誤爆防止
inoremap <C-@> <C-[>
xnoremap <C-@> <C-[>
vnoremap <C-@> <C-[>
cnoremap <C-@> <C-[>
onoremap <C-@> <C-[>
snoremap <C-@> <C-[>
lnoremap <C-@> <C-[>

" ZZ, ZQの誤爆防止
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" No help
nnoremap <F1> <NOP>

" Sの誤爆防止
nnoremap S <NOP>

" Bug fix of Y
nnoremap Y y$

" 直感的なredo
nnoremap U <C-r>

" Paste/Copy/Cut from clipboard
inoremap <C-v> <C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>
inoremap <A-v> <C-v>
inoremap <C-z> <C-v>
cnoremap <C-v> <C-r>+
cnoremap <A-v> <C-v>
cnoremap <C-z> <C-v>
xnoremap <C-c> "+y
xnoremap <C-x> "+d
xnoremap <C-v> "+p

" Set undo points <C-w> and <C-u>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-k> <C-g>u<C-\><C-o>D

" ======== From mswin.vim ========
" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" ======== Command mapping ========
" Clear highlighting search word -> moved to
nnoremap <silent> <ESC><ESC> :<C-u>nohl<CR><C-l>
nnoremap <silent> <C-l> :<C-u>nohl<CR><C-l>

" Normal mode additional mappings
nnoremap [Space]ss :<C-u>setlocal spell!<CR>
nnoremap [Space]d :<C-u>vertical diffsplit<Space>

" ======== CmdWin ========
" Close command line window with q
autocmd myvimrc CmdwinEnter * nnoremap <buffer> <nowait> q <C-w>c
autocmd myvimrc CmdwinEnter * startinsert
autocmd myvimrc CmdwinEnter * setlocal nonumber

"}}}

" ============================================
"  User Abbreviations {{{
" ============================================
" Abbreviations in isert modes.
"  -> Moved to after/plugin/abolish.vim
"}}}

" ============================================
"  User Script Command {{{
" ============================================

" ファイルを開いた時に前回のカーソル位置に移動
autocmd myvimrc BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif

" ======== Close current buffer keepig the window ========
" from http://nanasi.jp/articles/vim/kwbd_vim.html
:command! Q let kwbd_bn= bufnr("%")|enew|exe "bdel ".kwbd_bn|unlet kwbd_bn

" ======== Generate Ctags ========
command! Ctags call Ctags()
function! Ctags()
  " let ctags_target = input('Ctags: ', '')
  if &filetype ==# 'tex' || &filetype ==# 'bib'
    let ctags_target = '*.tex *.bib'
  else
    let ctags_target = '*.' . expand('%:e')
  endif
  if ctags_target !=# ''
    call system('cd '. expand('%:h') . '&&ctags ' . ctags_target )
  endif
endfunction

" ======== Clear all trailing whitespaces ========
command! RemoveTrailingSpases call RemoveTrailingSpases()
function! RemoveTrailingSpases()
  let l:p = getpos('.')
  silent! %s/\s\+$//e
  call setpos('.', l:p)
endfunction

"}}}

" ============================================
"  Terminal settings "{{{
" ============================================
if !has('gui_running')
  set t_Co=256
  " <Esc>のマッピングが持ってかれてアウト
  " imap OD <Left>
  " imap OC <Right>
  " imap OA <Up>
  " imap OB <Down>

  " Use vsplit mode
  " http://qiita.com/kefir_/items/c725731d33de4d8fb096
  if has('vim_starting') && has('vertsplit') && 0
    function! g:EnableVsplitMode()
      " enable origin mode and left/right margins
      let &t_CS = 'y'
      let &t_ti = &t_ti . '\e[?6;69h'
      let &t_te = '\e[?6;69l' . &t_te
      let &t_CV = '\e[%i%p1%d;%p2%ds'
      call writefile([ '\e[?6h\e[?69h' ], '/dev/tty', 'a')
    endfunction

    " old vim does not ignore CPR
    map <special> <Esc>[3;9R <Nop>

    " new vim can't handle CPR with direct mapping
    map <expr> [3;3R g:EnableVsplitMode()
    set t_F1=[3;3R
    map <expr> <t_F1> g:EnableVsplitMode()
    let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
  endif

  function! MyTermInit()
    map <Nul> <C-Space>
    xmap <Nul> <C-Space>
    smap <Nul> <C-Space>
    map! <Nul> <C-Space>
    " if exists(':ConoLineColorDark')
    "   ConoLineColorDark
    " endif
  endfunction

  " change the cursor shape depending on mode
  " see: http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
  if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif

  autocmd myvimrc VimEnter * call MyTermInit()
endif
"}}}

" ============================================
"    Filetype Dependent Settings"{{{
" ============================================
let python_no_builtin_highlight = 1
"}}}

" ============================================
"  Input Method Comntrol {{{
" ============================================

" ======== IM ========
" なんでこれ設定したんだっけ？
" IM onで<Shift>から英字入力するとneocomが動いて強制offだった？
" function! MyIMCheck()
"   if !exists(':NeoCompleteLock')
"     return
"   endif
"   let IMStatus = system('fcitx-remote')
"   if IMStatus < 2
"     exec 'NeoCompleteUnlock'
"   else
"     exec 'NeoCompleteLock'
"   endif
" endfunction
" autocmd myvimrc CursorMovedI * call MyIMCheck()

" insert mode を抜けた時に自動でIMEオフ
if executable('fcitx-remote')
  autocmd myvimrc InsertLeave * call system('fcitx-remote -c')
else
  autocmd myvimrc InsertLeave * set iminsert=0
endif

"}}}

" ============================================
"  Plugin settings  {{{
" ============================================

" ======== Unite ======== {{{
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif
"}}}

" ======== neomru ======== {{{
let g:neomru#file_mru_limit = 300 " Number of files saved in file_mru
let g:neomru#file_mru_ignore_pattern = (
  \ '\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\)$'
  \)
"}}}

" ======== VimFiler ========"{{{
let g:vimfiler_no_default_key_mappings = 1
let g:vimfiler_ignore_pattern = ['__pycache__', '.*\.pyc']
let g:vimfiler_as_default_explorer = 1
"}}}

" ======== Signify ======== {{{
let g:signify_sign_overwrite=1
let g:signify_vcs_list = ['git', 'hg']
if has('gui_running')
  " let g:signify_sign_add = '✚'
  " let g:signify_sign_change = '✔'
  " let g:signify_sign_delete = '✘'
  let g:signify_sign_add = '+'
  let g:signify_sign_change = '~'
  let g:signify_sign_delete = 'x'
else
  let g:signify_sign_add = '+'
  let g:signify_sign_change = '~'
  let g:signify_sign_delete = 'x'
endif
"}}}

" ======== visualstar ======== {{{
let g:visualstar_no_default_key_mappings = 1
"}}}

" ======== NeoComplete ======== {{{
let g:neocomplete#enable_at_startup = 1 " Use neocomplete.
let g:neocomplete#enable_smart_case = 1 " Use smartcase.
let g:neocomplete#sources#syntax#min_keyword_length = 2 " Set minimum syntax keyword length.
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default': '',
    \ 'vimshell': $HOME.'/.vimshell_hist',
    \ 'scheme': $HOME.'/.gosh_completions'
\ }

" Define keywords.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
" let g:neocomplete#sources#omni#input_patterns.nim = '[^. *\t]\.\w*'
"}}}

" ======== NeoSnippets ======== {{{
" let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory=[
      \ '~/.vim/snippets',
      \ '~/.vim/bundle/vim-snippets/snippets',
      \]
"}}}

" ======== sonic-template ======== {{{
let g:sonictemplate_vim_template_dir = '$HOME/.vim/template'
"}}}

" ======== Tcomment ======== {{{
" let g:tcommentMaps = 0
let g:tcommentMapLeader1 = ''
let g:tcommentMapLeader2 = ''
let g:tcommentMapLeaderOp1 = 'gc'  " gcb[text-obj] のmapが便利かもなので残す
let g:tcommentTextObjectInlineComment = ''
let g:tcommentMapLeaderUncommentAnyway = ''
let g:tcommentTextObjectInlineComment = ''  " Use textobj-user-comment
"}}}

" ======== surround.vim ======== {{{
let g:surround_no_mappings = 1
" Original insertmode mapping (delimitMateあればいらないかも)
let g:surround_no_insert_mappings = 1
"}}}

" ======== delimitMate ======== {{{
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_expand_cr = 1
let g:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|\$\|_\\s*\S\)'
augroup myvimrc
  autocmd FileType html,css,javascript,htmljinja,markdown let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
  autocmd FileType dart let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
  autocmd FileType tex,latex,plaintex let b:delimitMate_quotes = "\" ' ` $"
  autocmd FileType htmljinja,markdown let b:delimitMate_quotes = "\" ' ` %"
  autocmd FileType python let b:delimitMate_nesting_quotes = ['"',"'"]
  autocmd FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  autocmd FileType nim let b:delimitMate_nesting_quotes = ['"']
  autocmd FileType htmljinja let b:delimitMate_expand_space = 1
  autocmd FileType htmljinja let b:delimitMate_expand_inside_quotes = 1
  autocmd FileType htmljinja let b:delimitMate_expand_cr = 1
  autocmd FileType python let b:delimitMate_expand_cr = 1
  " autocmd FileType javascript,dart let b:delimitMate_eol_marker = ";"
augroup END
"}}}

" ======== smartchr ========"{{{
"}}}

" ======== TextObj-User ======== {{{
let g:textobj_wiw_no_default_key_mappings=1
"}}}

" ======== Rainbow parentheses ======== {{{
let g:rainbow_parentheses_disable_filetypes=['html', 'htmljinja', 'xml', 'css']
let g:rbpt_colorpairs = [
  \ ['16',          'black'],
  \ ['209',         'salmon'],
  \ ['69',          'CornflowerBlue'],
  \ ['202',         'orangered'],
  \ ['220',         'gold'],
  \ ['white',       'white'],
  \ ['21',          'blue'],
  \ ['48',          'springgreen'],
  \ ['63',          'slateblue'],
  \ ['red',         'darkred'],
  \ ['178',         'goldenrod'],
  \ ['lightgray',   'lightgray'],
  \ ['117',         'RoyalBlue2'],
  \ ['46',          'SeaGreen2'],
  \ ['93',          'DarkOrchid2'],
  \ ['196',         'firebrick2'],
  \ ]
"}}}

" ======== Indent-guides ======== {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 1
let g:indent_guides_color_change_percent = 4
" let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'rabbit-ui']
let g:indent_guides_color = 'dark'
"}}}

" ======== vimquickrun ======== {{{
" Default config
let g:quickrun_config = {}
let g:quickrun_config['_'] = {
      \ 'outputter/buffer/split': ':botright 8sp',
      \ 'runner/vimproc/updatetime': '10',
      \}

" ======== python ========
let g:quickrun_config['python'] = {
      \ 'runner': 'vimproc',
      \}
let g:quickrun_config['pytest'] = {
      \ 'command': 'py.test',
      \ 'runner': 'vimproc',
      \ 'cmdopt': '-s -v',
      \ 'exec': '%c %o %s',
      \ 'runmode': 'async:remote:vimproc',
      \ 'outputter/buffer/filetype': 'pytest_result',
      \ 'outputter/buffer/split': ':botright 12sp',
      \ 'hook/shebang/enable': 0,
      \ }
let g:quickrun_config['coffee'] = {
      \ 'outputter/buffer/split': ':botright 12sp',
      \ }
let g:quickrun_config['coffee_compile'] = {
      \ 'command': 'coffee',
      \ 'cmdopt': '-cbp',
      \ 'outputter/buffer/split': ':botright 12sp',
      \ }

" ======== watchdogs ========
let g:watchdogs_check_BufWritePost_enable = 0
let g:watchdogs_check_BufWritePost_enables = {
      \ 'javascript' : 1,
      \ 'coffee' : 1,
      \ 'typescript' : 1,
      \ 'nim' : 1,
      \ }

let g:watchdogs_check_CursorHold_enable = 0
let g:watchdogs_check_CursorHold_enables = {
      \ 'javascript' : 1,
      \ 'coffee' : 1,
      \ 'typescript' : 1,
      \ }

let g:quickrun_config['watchdogs_checker/_'] = {
      \ 'outputter/quickfix/open_cmd' : '',
      \ 'hook/qfstatusline_update/enable_exit' : 1,
      \ 'hook/qfstatusline_update/priority_exit' : 4,
      \ }

let g:quickrun_config['watchdogs_checker/jsxhint'] = {
      \ 'command' : 'jsxhint',
      \ 'cmdopt' : '--harmony',
      \ 'errorformat' : '%f: line %l\, col %c\, %m',
      \ }
" tutorial.js: line 2, col 3, Expected an identifier and instead saw '<'.

let g:quickrun_config['watchdogs_checker/vint'] = {
      \ 'command' : 'vint',
      \ 'errorformat' : '%f:%l:%c: %m',
      \ }

let g:quickrun_config['watchdogs_checker/nim'] = {
      \ 'cmdopt' : 'check --hint[Path]:off',
      \ }

let g:quickrun_config['vim/watchdogs_checker'] = {
      \ 'type' : 'watchdogs_checker/vint',
      \ }
let g:quickrun_config['typescript/watchdogs_checker'] = {
      \ 'type' : 'watchdogs_checker/tslint',
      \ }
"}}}

" ======== TagBar ======== {{{
if has('win32')
  let g:tagbar_ctags_bin = $HOME . '/Documents/Applications/ctagsJ/ctags.exe'
elseif has('mac')
  let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
endif

let g:tagbar_sort = 0  " Show tags in the order in the source file
let g:tagbar_left = 1
let g:tagbar_width = 32
let g:tagbar_indent = 1
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['▸', '▾']

" For markdown setting
let g:tagbar_type_markdown = {
      \ 'ctagstype' : 'markdown',
      \ 'kinds' : [
      \   'h:Headline',
      \ ],
      \ 'sort' : 0,
      \ }
let g:tagbar_type_nim = {
      \ 'ctagstype' : 'nim',
      \ 'kinds' : [
      \   'h:Headline',
      \   't:class',
      \   't:enum',
      \   't:tuple',
      \   't:subrange',
      \   't:proctype',
      \   'f:procedure',
      \   'f:method',
      \   'o:operator',
      \   't:template',
      \   'm:macro',
      \ ],
      \ 'sort' : 0,
      \ }
"}}}

" ======== colorizer ========"{{{
let g:colorizer_nomap = 1
"}}}

" ======== Solarized ======== {{{
let g:solarized_termcolors=256
let g:solarized_contrast='high'
"}}}

" ======== Badwolf ========"{{{
let g:badwolf_darkgutter = 1
"}}}

" ======== LightLine ======== {{{
set laststatus=2
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
let g:lightline_conf = $HOME . '/.vim/config/lightline_conf.vim'
if filereadable(g:lightline_conf)
  execute 'source ' . g:lightline_conf
endif
"}}}

" ======== Jedi-vim ======== {{{
let g:jedi#auto_vim_configuration=0
let g:jedi#completions_enabled = 0
" let g:jedi#auto_initialization=1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns={}
endif
let g:neocomplete#force_omni_input_patterns.python =
\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Jedi automatically starts the completion, if you type a dot, e.g. str., if you don't want this:
let g:jedi#popup_on_dot=1
" Jedi selects the first line of the completion menu.
" (for a better typing-flow and usually saves one keypress)
let g:jedi#popup_select_first=0
let g:jedi#auto_close_doc=0
let g:jedi#use_tabs_not_buffers=0

let g:jedi#completions_command='<C-j>'
let g:jedi#goto_assignments_command='gd'
let g:jedi#goto_definitions_command='gD'
let g:jedi#usages_command=''
let g:jedi#rename_command='<A-r>'
let g:jedi#documentation_command='K'
let g:jedi#show_call_signatures=1
let g:jedi#force_py_version=3
"}}}

" ======== pyflakes-vim ======== {{{
let g:pyflakes_use_quickfix=0
"}}}

" ========= vim-flake8 ======== {{{
if has('mac')
  let g:flake8_cmd='/usr/local/share/python/' . g:flake8_cmd
else
  let g:flake8_cmd = 'pep8'
endif
"}}}

" ======== vim-go ========"{{{
let g:go_disable_autoinstall = 1
let g:go_bin_path = expand('$GOPATH/bin')
"}}}

" ======== jscomplete ========"{{{
let g:jscomplete_use = ['dom']
"}}}

" ======== vim-json ========"{{{
let g:vim_json_syntax_conceal = 0
"}}}

" }}}

" ============================================
"  My Plugin Settings  {{{
" ============================================

" ======== conoline.vim ======== {{{
let g:conoline_use_colorscheme_default_normal = 0
let g:conoline_use_colorscheme_default_insert = 0
let g:conoline_auto_enable = has('gui_running')
let g:conoline_color_normal_dark = 'guibg=#181818 ctermbg=234'
let g:conoline_color_insert_dark = 'guibg=#000000 ctermbg=232'
let g:conoline_color_normal_nr_dark = 'guibg=#181818 ctermbg=234'
let g:conoline_color_insert_nr_dark = 'guibg=#000000 ctermbg=232'
"}}}

" ======== seiya ======== {{{
let g:seiya_auto_enable=0
"}}}

" ======== SidePanel.vim ======== {{{
let g:sidepanel_pos = 'left'
let g:sidepanel_width = 26
let g:sidepanel_config = {}
let g:sidepanel_config['nerdtree'] = {}
let g:sidepanel_config['tagbar'] = {}
let g:sidepanel_config['vimfiler'] = {}
let g:sidepanel_use_rabbit_ui = 0
"}}}

" ======== quick-closer.vim ======== {{{
let g:quick_closer_filetypes = [
      \ 'capture',
      \ 'help',
      \ 'nerdtree',
      \ 'quickrun',
      \ 'nose_result',
      \ 'ref-pydoc',
      \ 'qf',
      \ 'netrw',
      \ ]
"}}}

" ======== livemark.vim ======== {{{
let g:livemark_css_files = [expand('~/dotfiles/static/css/bootstrap.ja.min.css')]
let g:livemark_no_default_css = 1
"}}}

" ======== AsyncJedi ========"{{{
let g:asyncjedi_no_detail = 1
"}}}

"}}}


" ============================================
"  Post process {{{
" ============================================

" ======== Read local settings ('~/.vimrc.local') ========
" http://vim-users.jp/2009/12/hack108/
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" ======== Load plugin settings on start up ========
if filereadable(expand('~/.vim/config/plugins.vim'))
  autocmd myvimrc VimEnter * source ~/.vim/config/plugins.vim
endif

" ======== Record and show startup time ========
if has('vim_starting') && has('reltime')
  augroup myvimrc
    autocmd VimEnter * echomsg 'startuptime: ' . reltimestr(reltime(g:startuptime))
  augroup END
endif

"}}}

packadd matchit
" vim set\ fdm=marker\ ts=2\ sts=2\ sw=2\ tw=0\ et
