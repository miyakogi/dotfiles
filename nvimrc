set encoding=utf-8
scriptencoding utf-8

" ======== encoding ======== {{{
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp932,iso-2022-jp,euc-jp,default,latin
set fileformats=unix,dos,mac
set shellslash  " Necessary for windows
"}}}

" ======== Startup ======== {{{
augroup myvimrc
  autocmd!
augroup MyVimEnter
  autocmd!
  autocmd VimEnter * autocmd! MyVimEnter
augroup END

" Measure startup time
" https://gist.github.com/1518874
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup myvimrc
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

let g:MyColorScheme = 'badwolf'
"}}}

" ============================================
"  Plugin List  {{{
" ============================================

" ======== NeoBundle ======= {{{
set runtimepath+=~/.config/nvim/bundle/neobundle.vim
call neobundle#begin(expand('~/.config/nvim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'
let g:neobundle#log_filename = expand('~/.vim/bundle/.neobundle/neobundle.log')
let g:neobundle#install_max_processes = 4
let g:neobundle#install_process_timeout = 180
let g:neobundle#types#git#enable_submodule = 1
" }}}

NeoBundle 'vim-jp/vital.vim'

" ======== File/Buffer management ======== {{{
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'justinmk/vim-dirvish'
NeoBundle 'scrooloose/nerdtree'
NeoBundleLazy 'ujihisa/unite-locate', {
      \ 'depends': 'Shougo/unite.vim',
      \ 'autoload': {'unite_sources': 'locate'}}
" }}}

" ======== VCS ======== {{{
NeoBundle 'tpope/vim-fugitive', {'augroup': 'fugitive'}
NeoBundle 'https://bitbucket.org/ludovicchabant/vim-lawrencium',
      \ {'augroup': 'lawrencium_detect'}
NeoBundle 'mhinz/vim-signify'
"}}}

" ======== Search/Move in buffer ======== {{{
NeoBundleLazy 'osyo-manga/vim-anzu', {'autoload': {
      \ 'mappings': [['n', '<Plug>(anzu-']],
      \ 'functions': ['anzu#mode#mapexpr'],
      \ }}
NeoBundleLazy 'thinca/vim-visualstar', {
      \ 'autoload': {'mappings': [['x', '<Plug>(visualstar-']]}}
"}}}

" ======== Ctags ======== {{{
NeoBundleLazy 'majutsushi/tagbar', {
      \ 'autoload': { 'commands': ["TagbarOpen", "TagbarClose"] }}
"}}}

" ======== Input support ======== {{{
NeoBundleLazy 'Shougo/deoplete.nvim', {'insert': 1}
NeoBundleLazy 'Shougo/neosnippet', {'insert': 1}
NeoBundleLazy 'Shougo/neosnippet-snippets', {'insert': 1}
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-surround'
NeoBundleLazy 'kana/vim-repeat', {'autoload': {'mappings': '.'}}
"}}}

" ======== Smart Input/Edit ======== {{{
NeoBundleLazy 'Raimondi/delimitMate', {'insert': 1}
NeoBundle 'kana/vim-smartchr'
" Switch to camelCase (crc), MixedCase (crm), snake_case (crs, cr_), and UPPER_CASE (cru)
NeoBundle 'tpope/vim-abolish' " Better Abbreviations
"}}}

" ======== Text object ======== {{{
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-line'
NeoBundle 'h1mesuke/textobj-wiw'
NeoBundle 'sgur/vim-textobj-parameter'
NeoBundle 'glts/vim-textobj-comment'
"}}}

" ======== Syntax Checkers/Helpers ======== {{{
" NeoBundle 'scrooloose/syntastic'
NeoBundle 'benekastah/neomake'
NeoBundle 'kien/rainbow_parentheses.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
"}}}

" ======== Quick run ======== {{{
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle "cohama/vim-hier"
NeoBundle "KazuakiM/vim-qfstatusline"
"}}}

" ======== Not Categorized ======== {{{
NeoBundleLazy "osyo-manga/unite-quickfix", {
      \ 'autoload' : {'unite_sources': ['quickfix', 'location_list']},
      \ 'depends': 'Shougo/unite.vim' }
NeoBundleLazy 'AndrewRadev/linediff.vim', {
      \ 'autoload': {'commands': 'Linediff'}}
"}}}

" ============================================
"  Color and view control plugins  {{{
" ============================================

" ======== Colorschemes ========
NeoBundle 'altercation/vim-colors-solarized'

" ======== Status/Tab line ========
NeoBundle 'itchyny/lightline.vim'

" ======== Cursor position ========
NeoBundle 'itchyny/vim-cursorword'

"}}}

" ============================================
"  Filetype dependent plugins  {{{
" ============================================

" ======== Python ========
NeoBundleLazy 'miyakogi/vim-flake8', {'autoload': {
      \ 'filetypes': ['python', 'python3', "nose", 'python.nose',
      \               'python.nose3', 'python.pytest', 'pytest', 'cython']}}
NeoBundle "miyakogi/vim-virtualenv"
NeoBundleLazy 'hynek/vim-python-pep8-indent', {"autoload": {
      \ "filetypes": ["python", "python3", "python.nose", "python.nose3",
      \               "nose", "python.pytest", "pytest", "cython"]}}
NeoBundleLazy 'mitsuhiko/vim-jinja', {
            \ "autoload": {"filetypes": ["htmljinja", "html"],
            \              "filename_patterns": ["\.jinja$", "\.jinja2$"]}}

" ======== Go lang ========
NeoBundleLazy 'vim-jp/go-vim', {
      \ "autoload": {"filetypes": ["go"] }, "depends": "fatih/vim-go"}
NeoBundleLazy 'fatih/vim-go', {"autoload": {"filetypes": ["go"] }}

" ======== Nim ========
" NeoBundle 'zah/nimrod.vim'
NeoBundle 'miyakogi/nimrod.vim', 'dev'

" ======== Markdown ========
NeoBundleLazy 'tpope/vim-markdown', {"autoload": {"filetypes": ["markdown"]}}

" ======== JavaScript ========
NeoBundleLazy 'jelera/vim-javascript-syntax', {
      \ 'autoload': {'filetypes': ['javascript', 'html']}}
NeoBundleLazy 'jason0x43/vim-js-indent', {
      \ 'autoload': {'filetypes': ['javascript', 'html', 'typescript']}}

" ======== JSON ========
NeoBundleLazy 'elzr/vim-json', {
      \ 'autoload': {'filename_patterns': '\.json$'}}

" ======== HTML ========
NeoBundle 'mustache/vim-mustache-handlebars'

" "}}}

" "}}}

" ============================================
"  My Plugins"{{{
" ============================================
NeoBundle 'miyakogi/conoline.vim'
NeoBundle 'miyakogi/slateblue.vim'
NeoBundle 'miyakogi/sidepanel.vim'
NeoBundle 'miyakogi/seiya.vim'

let g:local_plugin_dir = $HOME . '/.config/nvim/local_plugin'
let g:local_plugins = [
      \  'livemark.vim',
      \  'vim-mypy',
      \ ]
NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'autoload': {
      \   'filetypes': ['python', 'python3', 'nose', 'python.nose', 'python.nose3',
      \                 'python.pytest', 'pytest', 'cython']},
      \ }
call neobundle#local(g:local_plugin_dir, {}, g:local_plugins )

" }}}

call neobundle#end()

" ============================================
"  Set Filetypes{{{
" ============================================

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

function! MyFirstInsert()
  if exists('g:colors_name')
    execute 'colorscheme ' . g:colors_name
  endif
  autocmd! first_insert
endfunction

augroup first_insert
  autocmd!
  autocmd InsertEnter * nested call MyFirstInsert()
augroup END

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
let g:loaded_matchparen=0

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
autocmd myvimrc CmdWinEnter * nnoremap <buffer> <nowait> q <C-w>c
autocmd myvimrc CmdwinEnter * startinsert
autocmd myvimrc CmdwinEnter * setlocal nonumber

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
set t_Co=256
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
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
  syntax on
  execute 'colorscheme ' . g:MyColorScheme
  if exists('g:loaded_lightline')
    call lightline#colorscheme()
  endif
  if exists(':ConoLineColorDark')
    ConoLineColorDark
    ConoLineEnable
  endif
  autocmd! MyTermInit
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

augroup MyTermInit
  autocmd BufEnter * call MyTermInit()
augroup END
" autocmd myvimrc VimEnter * call MyTermInit()
"}}}

" ============================================
"  Filetype Dependent Settings"{{{
" ============================================

" ======== Markdown ========
autocmd myvimrc Syntax markdown syntax sync fromstart
autocmd myvimrc Syntax rst syntax sync fromstart
autocmd myvimrc Syntax python syntax sync fromstart
"}}}


" ============================================
"  Plugin settings  {{{
" ============================================

" ======== Unite ======== {{{
if neobundle#is_installed('unite.vim')
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
  nnoremap <silent> [unite]j :<C-u>Unite junkfile<CR>
  nnoremap <silent> <Leader>jf :<C-u>Unite junkfile/new -start-insert<CR>
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

" ======== neomru ========
let g:neomru#file_mru_limit = 300 " Number of files saved in file_mru
" Ignore file set
" Default (see autoload/unite/sources/file_mru.vim)
" let g:unite_source_file_mru_ignore_pattern = (
  " \ '\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\)$'
  " \ '\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'
  " \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'
  " \)
let g:neomru#file_mru_ignore_pattern = (
  \ '\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\)$'
  \)

"}}}

" ======== NERDTree ======== {{{
let g:NERDTreeIgnore = [
      \ '\.orig$',
      \ 'swp$',
      \]
" TeX関係
let g:NERDTreeIgnore+=[
      \ '\.aux$',
      \ '\.bbl$',
      \ '\.blg$',
      \ '\.dvi$',
      \ '\.gz$',
      \ '\.orig$',
      \ '\.out$',
      \ '\.pbm$',
      \ '\.pdf$',
      \ '\.xbb$',
      \]
" python
let g:NERDTreeIgnore+=[
      \ '\.pyc$',
      \ '^__pycache__$',
      \ '\.egg$',
      \ '\.egg-info$',
      \]
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeWinPos='left'
let g:NERDTreeWinSize=32

" close NERDTree window after opening a file
let g:NERDTreeQuitOnOpen=0
let g:NERDTreeShowBookmarks=1
let g:NERDTreeChDirMode=1
let g:NERDTreeHighlightCursorline=has('gui_running')
let g:NERDTreeHijackNetrw=0

" Start NERDTree on vim start up when any additional parameters are applied.
" let file_name = expand("%")
" if has('vim_starting') && file_name == ""
"   autocmd Vimenter * NERDTree Documents
" endif
"}}}

" ======== VimFiler ========"{{{
if neobundle#is_installed('vimfiler.vim')
  let g:vimfiler_no_default_key_mappings = 1

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

if neobundle#is_installed('vim-signify')
  autocmd myvimrc ColorScheme,Syntax * highlight link SignifySignAdd LineNr
                            \ | highlight link SignifySignChange PreProc
                            \ | highlight SignifySignDelete guifg=#EE3333 ctermfg=red
endif
"}}}

" ======== anzu ======== {{{
if neobundle#is_installed('vim-anzu')
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
let g:visualstar_no_default_key_mappings = 1
if neobundle#is_installed('vim-visualstar')
  xmap * <Plug>(visualstar-*)
  xmap g* <Plug>(visualstar-g*)
  xmap # <Plug>(visualstar-#)
  xmap g# <Plug>(visualstar-g#)
endif
"}}}

" ======== NeoComplete ======== {{{
let g:deoplete#enable_at_startup = 1 " Use neocomplete.
let g:deoplete#enable_smart_case = 1 " Use smartcase.
let g:deoplete#sources#syntax#min_keyword_length = 2 " Set minimum syntax keyword length.
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define keywords.
if !exists('g:deoplete#keyword_patterns')
  let g:deoplete#keyword_patterns = {}
endif

if neobundle#is_installed('deoplete.nvim')
  let g:deoplete#keyword_patterns['default'] = '\h\w*'
  " ======== Key mappings ========
  " inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr> <C-x><C-f> g:deoplete#start_manual_complete('file')
  inoremap <expr> <Tab> pumvisible() ? deoplete#complete_common_string() : "\<TAB>"

  " ==== Recommended key-mappings ====
  inoremap <silent><expr> <CR> MyNeocomCR()
  function! MyNeocomCR()
    let l:delimitMateCR = delimitMate#ExpandReturn()
    return deoplete#mappings#close_popup() . l:delimitMateCR
  endfunction

  " <TAB>: completion.
  " inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

  " Enable omni completion.
  augroup myvimrc
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType nim setlocal omnifunc=NimComplete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END

  " Enable heavy omni completion.
  if !exists('g:deoplete#sources#omni#input_patterns')
    let g:deoplete#sources#omni#input_patterns = {}
  endif
  let g:deoplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:deoplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:deoplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:deoplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
  " let g:neocomplete#sources#omni#input_patterns.nim = '[^. *\t]\.\w*'
endif

"}}}

" ======== NeoSnippets ======== {{{
" let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory=[
      \ '~/.vim/snippets',
      \ '~/.vim/bundle/vim-snippets/snippets',
      \]

if neobundle#is_installed('neosnippet')
  imap <C-Space> <Plug>(neosnippet_expand_or_jump)
  smap <C-Space> <Plug>(neosnippet_expand_or_jump)

  " For snippet_complete marker.
  " if has('conceal')
  "   set conceallevel=2 concealcursor=i
  " endif
endif
"}}}

" ======== Sonic Template ======== {{{
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

if neobundle#is_installed('tcomment_vim')
  nnoremap gcl      :TCommentRight<CR>
  nnoremap gcp      vip:TCommentBlock<CR>
  xnoremap gb       :TCommentBlock<CR>
  xnoremap gi       :TCommentInline<CR>
  imap     <C-g>c   <C-o>:TComment<CR>
  imap     <C-g>l   <C-o>:TCommentRight<CR>
endif
"}}}

" ======== surround.vim ======== {{{
let g:surround_no_mappings = 1
" Original insertmode mapping (delimitMateあればいらないかも)
let g:surround_no_insert_mappings = 1

if neobundle#is_installed('vim-surround')
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
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_expand_cr = 1
let g:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|\$\|_\\s*\S\)'

if neobundle#is_installed('delimitMate')
  imap <C-j> <PLug>delimitMateS-Tab
  smap <C-j> <PLug>delimitMateS-Tab
  imap <C-h> <BS>

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
endif
"}}}

" ======== smartchr ========"{{{
if neobundle#is_installed('vim-smartchr')
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
endif
"}}}

" ======== TextObj-User ======== {{{
let g:textobj_wiw_no_default_key_mappings=1
if neobundle#is_installed('vim-textobj-user')
  if neobundle#is_installed('textobj-wiw')
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

  call textobj#user#plugin('heredoc', {
        \ 'doc': {
        \   'select-a-function': 'SelectHereDocA',
        \     'select-a': "ah",
        \   'select-i-function': 'SelectHereDocI',
        \     'select-i': "ih",
        \  },
        \ })

  autocmd FileType python,python.pytest let b:heredoc_start_pattern = '\v(''''''|""")'
  autocmd FileType python,python.pytest let b:heredoc_end_pattern = '\v(''''''|""")'
  autocmd FileType go let b:heredoc_start_pattern = '\v`'
  autocmd FileType go let b:heredoc_end_pattern = '\v`'
endif
"}}}

" ======== Syntastic ======== {{{
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
      \   'sh', 'php', 'perl', 'ruby', 'c', 'cpp', 'javascript', 'coffee', 'python',
      \ ],
      \ 'passive_filetypes': [
      \   'python', 'latex', 'tex', 'vim', 'dart',
      \ ]
      \}
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

if neobundle#is_installed('syntastic')
  autocmd myvimrc ColorScheme,Syntax * hi SyntasticErrorSign ctermfg=red ctermbg=234 guifg=#f03300 guibg=grey8 gui=bold
  autocmd myvimrc ColorScheme,Syntax * hi SyntasticErrorLine cterm=underline gui=underline
endif
"}}}

" ======== NeoMake ========"{{{
let g:neomake_javascript_enabled_makers = ['jshint']
let g:neomake_python_enabled_makers = ['pyflakes']
let g:neomake_go_enabled_makers = []
let g:neomake_error_sign = {'text': 'E>', 'texthl': 'ErrorSign'}
let g:neomake_warning_sign = {'text': 'W>', 'texthl': 'WarningSign'}
if neobundle#is_installed('neomake')
  autocmd myvimrc ColorScheme,Syntax * hi ErrorSign ctermfg=red ctermbg=234 guifg=#f03300 guibg=grey8 gui=bold
  autocmd myvimrc ColorScheme,Syntax * hi WarningSign ctermfg=yellow ctermbg=34 guifg=#8fc947 guibg=grey8 gui=bold
  autocmd myvimrc BufWritePost * Neomake
endif
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


if neobundle#is_installed('rainbow_parentheses.vim')
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
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 1
let g:indent_guides_color_change_percent = 4
" let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'rabbit-ui']
let g:indent_guides_color = 'dark'

if neobundle#is_installed('vim-indent-guides')
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
if neobundle#is_installed('vim-quickrun')
  " NeoBundleLazy fails with mappings:<leader>r
  map <Leader>r <Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
endif

" Default config
let g:quickrun_config = {}
let g:quickrun_config['_'] = {
      \ 'outputter/buffer/split': ':botright 8sp',
      \}

" Python
let g:py_runner='system'
let g:quickrun_config['python'] = {
      \ 'runner': g:py_runner,
      \}
" Python nosetests
let g:quickrun_config['nose'] = deepcopy(g:quickrun_config.python)
let g:quickrun_config.nose['command'] = 'nosetests'
let g:quickrun_config.nose['cmdopt'] = '-s -vv ./test*.py'
let g:quickrun_config.nose['exec'] = '%c %o'
let g:quickrun_config.nose['outputter/buffer/filetype'] = 'nose_result'
let g:quickrun_config.nose['hook/shebang/enable'] = 0

let g:quickrun_config['python.nose'] = deepcopy(g:quickrun_config.nose)
let g:quickrun_config['python.nose'].cmdopt = '-s -vv '
let g:quickrun_config['python.nose'].exec = '%c %o %s'
let g:quickrun_config['nose_cover'] = deepcopy(g:quickrun_config.nose)
let g:quickrun_config['nose_cover'].cmdopt = '-s -vv ./test*.py --with-coverage'
let g:quickrun_config['nose_cover']['outputter/buffer/split'] = ':20sp'

" For python3
function! NoseCommand()
  let pyver = system('python -V')[7:9]
  let nosecmd = 'nosetests-' . pyver[0]
  if executable(nosecmd)
    return nosecmd
  endif
  let nosecmd = 'nosetests-' . pyver
  if executable(nosecmd)
    return nosecmd
  endif
  return 'nosetests'
endfunction

let g:quickrun_config['python.nose3'] = deepcopy(g:quickrun_config['python.nose'])
let g:quickrun_config['python.nose3']['command'] = 'nosetests-3.4'
let g:quickrun_config['nose3'] = deepcopy(g:quickrun_config['nose'])
let g:quickrun_config['nose3']['command'] = 'nosetests-3.4'
let g:quickrun_config['nose3_cover'] = deepcopy(g:quickrun_config['nose_cover'])
let g:quickrun_config['nose3_cover']['command'] = 'nosetests-3.4'

" Py.test
let g:quickrun_config['pytest'] = {
      \ 'command': 'py.test',
      \ 'runner': g:py_runner,
      \ 'cmdopt': '-s -v',
      \ 'exec': '%c %o %s',
      \ 'runmode': 'async:remote:vimproc',
      \ 'outputter/buffer/filetype': 'pytest_result',
      \ 'outputter/buffer/split': ':botright 12sp',
      \ 'hook/shebang/enable': 0,
      \ }
let g:quickrun_config['python.pytest'] =deepcopy(g:quickrun_config['pytest'])
let g:quickrun_config['python.pytest3'] = deepcopy(g:quickrun_config['python.pytest'])
let g:quickrun_config['python.pytest3']['command'] = 'py.test-3.4'
let g:quickrun_config['pytest3'] = deepcopy(g:quickrun_config['pytest'])
let g:quickrun_config['pytest3']['command'] = 'py.test-3.4'

let g:quickrun_config['go'] = {
      \ 'command': 'go',
      \ 'cmdopt': 'run',
      \ 'exec': '%c %o %s',
      \}
let g:quickrun_config['javascript'] = {
      \ 'command': 'node',
      \ }
let g:quickrun_config['coffee'] = {
      \ 'outputter/buffer/split': ':botright 12sp',
      \ }
let g:quickrun_config['coffee_compile'] = {
      \ 'command': 'coffee',
      \ 'cmdopt': '-cbp',
      \ 'outputter/buffer/split': ':botright 12sp',
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

" ======== Badwolf ========"{{{
let g:badwolf_darkgutter = 1
"}}}

" ======== LightLine ======== {{{
set laststatus=2
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
let g:lightline_conf = $HOME . '/.config/nvim/config/lightline_conf.vim'

if neobundle#is_installed('lightline.vim')
  if filereadable(g:lightline_conf)
    execute 'source ' . g:lightline_conf
  endif
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
let g:neocomplete#force_omni_input_patterns['python.pytest'] =
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

if neobundle#is_installed('jedi-vim')
  command! JediRename call jedi#rename()
endif
"}}}


"}}}

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
if neobundle#is_installed('conoline.vim')
  nnoremap [Space]sc :<C-u>ConoLineToggle<CR>
        \ :<C-u>echo conoline#status() ?
        \ 'ConoLine Enable' : 'ConoLine Disable'<CR>
endif
"}}}

" ======== seiya ======== {{{
let g:seiya_auto_enable = 1
let g:seiya_target_groups = ['ctermbg', 'guibg']
"}}}

" ======== SidePanel.vim ======== {{{
let g:sidepanel_pos = 'left'
let g:sidepanel_width = 26
let g:sidepanel_config = {}
let g:sidepanel_config['nerdtree'] = {}
let g:sidepanel_config['tagbar'] = {}
" let g:sidepanel_config['gundo'] = {}
" let g:sidepanel_config['buffergator'] = {}
let g:sidepanel_config['vimfiler'] = {}

let g:sidepanel_use_rabbit_ui = 0

if neobundle#is_installed('sidepanel.vim')
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

" ======== quick-closer.vim ======== {{{
let g:quick_closer_filetypes = [
      \ 'capture',
      \ 'help',
      \ 'nerdtree',
      \ 'quickrun',
      \ 'nose_result',
      \ 'ref-pydoc',
      \ 'qf',
      \ ]
"}}}

" ======== jedi_web ======== {{{
if neobundle#is_installed('jedi_web')
  augroup myvimrc
    autocmd FileType python nnoremap <buffer> gl :<C-u>call jedi_web#goto_usages()<CR>
    autocmd FileType python nnoremap <buffer> gd :<C-u>call jedi_web#goto_assignments()<CR>
    autocmd FileType python nnoremap <buffer> gD :<C-u>call jedi_web#goto_definitions()<CR>
    " autocmd FileType python nnoremap <buffer> K  :<C-u>call jedi_web#show_documents()<CR>
  augroup END
  let g:jedi_web_port=8889
  let g:jedi_web_autoenable_call_signatures = 0
endif
"}}}

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
  " inoremap <silent> <ESC> <Esc>:<C-u>call system('fcitx-remote -c')<CR>
else
  autocmd myvimrc InsertLeave * set iminsert=0
  " inoremap <silent> <ESC> <Esc>:set iminsert=0<CR>
endif

"}}}

" ============================================
"  GUI"{{{
" ============================================
function! s:guicursor_set()
  if &background == 'dark'
    highlight iCursor guifg=white guibg=grey75
    highlight rCursor guifg=white guibg=#dd2222
    highlight oCursor guifg=white guibg=#dd2222
  else
    highlight iCursor guifg=black guibg=grey25
    highlight rCursor guifg=black guibg=#dd2222
    highlight oCursor guifg=black guibg=#dd2222
  endif

  set guicursor=
        \n-v-c:block-Cursor/lCursor-blinkwait750-blinkon700-blinkoff400,
        \ve:ver35-oCursor-blinkwait250-blinkon400-blinkoff250,
        \o:hor50-oCursor-blinkwait250-blinkon400-blinkoff250,
        \i-ci:ver12-iCursor/lCursor-blinkwait50-blinkon850-blinkoff550,
        \r-cr:hor10-rCursor/lCursor-blinkwait0-blinkon0-blinkoff0,
        \sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
      " \n-v-c:hor4-Cursor/lCursor-blinkwait750-blinkon850-blinkoff550,
endfunction

augroup guicursor
  autocmd!
  " autocmd Syntax,ColorScheme * call s:guicursor_set()
augroup END

"}}}


" ============================================
"  Post process {{{
" ============================================

" ======== Read local settings ('~/.vimrc.local') ========
" http://vim-users.jp/2009/12/hack108/
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

if v:version >= 704
  set re=2
endif

let g:tex_fold_enabled=1
" set foldmethod=syntax
let g:tex_comment_nospell=1

"}}}

" vim set\ fdm=marker\ ts=2\ sts=2\ sw=2\ tw=0\ et

