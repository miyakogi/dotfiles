if !has("gui_running") && &t_Co != 88 && &t_Co != 256
    finish
endif

set background=dark

if exists("syntax_on")
    syntax reset
endif

let colors_name = "caffe"

" Palette {{{

let s:plt = {}

" The most basic of all our colors is a slightly tweaked version of the Molokai
" Normal text.
let s:plt.front = 255
let s:plt.back = 234

" All of the gray70 colors are based on a brown from Clouds Midnight.
let s:plt.gray90 = 252
let s:plt.gray80 = 245
let s:plt.gray70 = 243
let s:plt.gray60 = 241
let s:plt.gray50 = 238
let s:plt.gray40 = 236
let s:plt.gray30 = 235
let s:plt.gray20 = 234
let s:plt.gray10 = 233

" A color sampled from a highlight in a photo of a glass of Dale's Pale Ale on
" my desk.
let s:plt.yellow = 220
let s:plt.yellow1 = 221

let s:plt.flesh = 223

" Delicious, chewy red from Made of Code for the poppiest highlights.
let s:plt.red = 196

" The star of the show comes straight from Made of Code.
"
" You should almost never use this.  It should be used for things that denote
" 'where the user is', which basically consists of:
"
" * The cursor
" * A REPL prompt
let s:plt.blue = 39

" This one's from Mustang, not Florida!
let s:plt.orange = 214

" A limier green from Getafe.
let s:plt.lime = 154

" Rose's pink in The Idiot's Lantern.
let s:plt.pink = 211

" Another play on the brown from Clouds Midnight.  I love that color.
let s:plt.lightbrown = 137

" Also based on that Clouds Midnight brown.
let s:plt.coffee    = 173
let s:plt.darkbrown = 95

let s:plt.purple = 198
let s:plt.deeppurple = 161

call termcolor#set_pallet(s:plt)
" }}}

call termcolor#hl('Normal', 'front', 'back')

call termcolor#hl('Folded', 'gray60', 'bg', 'none')
call termcolor#hl('VertSplit', 'gray10', 'gray10', 'none')

call termcolor#hl('CursorLine',   '', 'gray10', 'none')
call termcolor#hl('CursorColumn', '', 'gray10')
call termcolor#hl('ColorColumn',  '', 'gray10')

call termcolor#hl('TabLine', 'front', 'gray70', 'none')
call termcolor#hl('TabLineFill', 'front', 'gray70', 'none')
call termcolor#hl('TabLineSel', 'back', 'blue', 'none')

call termcolor#hl('MatchParen', 'yellow1', 'gray30', 'bold')

call termcolor#hl('NonText',    'gray50', 'bg')
call termcolor#hl('SpecialKey', 'gray50', 'bg')

call termcolor#hl('Visual',    '',  'gray30')
call termcolor#hl('VisualNOS', '',  'gray30')

call termcolor#hl('Search',    'back', 'yellow', 'bold')
call termcolor#hl('IncSearch', 'back', 'blue',    'bold')

call termcolor#hl('Underlined', 'fg', '', 'underline')

call termcolor#hl('StatusLine',   'back', 'blue',     'bold')
call termcolor#hl('StatusLineNC', 'front', 'gray20', 'bold')

call termcolor#hl('Directory', 'flesh', '', 'bold')

call termcolor#hl('Title', 'yellow')

call termcolor#hl('ErrorMsg',   'red',       'bg', 'bold')
call termcolor#hl('MoreMsg',    'yellow',   '',   'bold')
call termcolor#hl('ModeMsg',    'flesh', '',   'bold')
call termcolor#hl('Question',   'flesh', '',   'bold')
call termcolor#hl('WarningMsg', 'pink',       '',   'bold')

" This is a ctags tag, not an HTML one.  'Something you can use c-] on'.
call termcolor#hl('Tag', '', '', 'bold')

" hi IndentGuides                  guibg=#373737
" hi WildMenu        guifg=#66D9EF guibg=#000000

" }}}
" Gutter {{{

call termcolor#hl('LineNr',     'gray60', 'gray20')
call termcolor#hl('SignColumn', '',       'gray20')
call termcolor#hl('FoldColumn', 'gray60', 'gray20')

" }}}
" Cursor {{{

call termcolor#hl('Cursor',  'back', 'blue', 'bold')
call termcolor#hl('vCursor', 'back', 'blue', 'bold')
call termcolor#hl('iCursor', 'back', 'blue', 'none')

" }}}
" Syntax highlighting {{{

" Start with a simple base.
call termcolor#hl('Special', 'front')

" Comments are slightly brighter than folds, to make 'headers' easier to see.
call termcolor#hl('Comment',        'gray70')
call termcolor#hl('Todo',           'front', 'bg', 'bold')
call termcolor#hl('SpecialComment', 'front', 'bg', 'bold')

" Strings are a nice, pale straw color.  Nothing too fancy.
call termcolor#hl('String', 'flesh')

" Control flow stuff is red.
call termcolor#hl('Statement',   'deeppurple', '', 'bold')
call termcolor#hl('Keyword',     'deeppurple', '', 'bold')
call termcolor#hl('Conditional', 'deeppurple', '', 'bold')
call termcolor#hl('Operator',    'purple', '', 'none')
call termcolor#hl('Label',       'purple', '', 'none')
call termcolor#hl('Repeat',      'purple', '', 'none')

" Functions and variable declarations are orange, because front looks weird.
call termcolor#hl('Identifier', 'orange', '', 'none')
call termcolor#hl('Function',   'orange', '', 'none')

" Preprocessor stuff is lime, to make it pop.
"
" This includes imports in any given language, because they should usually be
" grouped together at the beginning of a file.  If they're in the middle of some
" other code they should stand out, because something tricky is
" probably going on.
call termcolor#hl('PreProc',   'yellow', '', 'none')
call termcolor#hl('Macro',     'yellow', '', 'none')
call termcolor#hl('Define',    'yellow', '', 'none')
call termcolor#hl('PreCondit', 'yellow', '', 'bold')

" Constants of all kinds are colored together.
" I'm not really happy with the color yet...
call termcolor#hl('Constant',  'lightbrown', '', 'none')
call termcolor#hl('Character', 'lightbrown', '', 'bold')
call termcolor#hl('Boolean',   'lightbrown', '', 'bold')

call termcolor#hl('Number', 'flesh', '', 'none')
call termcolor#hl('Float',  'flesh', '', 'none')

" Not sure what 'special character in a constant' means, but let's make it pop.
call termcolor#hl('SpecialChar', 'pink', '', 'bold')

call termcolor#hl('Type', 'pink', '', 'none')
call termcolor#hl('StorageClass', 'coffee', '', 'none')
call termcolor#hl('Structure', 'coffee', '', 'none')
call termcolor#hl('Typedef', 'coffee', '', 'bold')

" Make try/catch blocks stand out.
call termcolor#hl('Exception', 'red', '', 'bold')

" Misc
call termcolor#hl('Error',  'front',   'red', 'bold')
call termcolor#hl('Debug',  'front',   '',      'bold')
call termcolor#hl('Ignore', 'gray70', '',      '')

" }}}
" Completion Menu {{{

call termcolor#hl('Pmenu', 'front', 'gray40')
call termcolor#hl('PmenuSel', 'back', 'blue', 'bold')
call termcolor#hl('PmenuSbar', '', 'gray40')
call termcolor#hl('PmenuThumb', 'gray90')

" }}}
" Diffs {{{

call termcolor#hl('DiffDelete', 'back', 'back')
call termcolor#hl('DiffAdd',    '',     'gray40')
call termcolor#hl('DiffChange', '',     'darkgray70')
call termcolor#hl('DiffText',   'front', 'gray40', 'bold')

" }}}
" Spelling {{{

if has("spell")
    call termcolor#hl('SpellCap', 'yellow', 'bg', 'undercurl,bold', 'yellow')
    call termcolor#hl('SpellBad', '', 'bg', 'undercurl', 'red')
    call termcolor#hl('SpellLocal', '', 'bg', 'undercurl', 'lime')
    call termcolor#hl('SpellRare', '', 'bg', 'undercurl', 'blue')
endif

" }}}

" ============================================
"  Filetype-specific {{{
" ============================================
" ======== Django ======== {{{
call termcolor#hl('djangoArgument', 'flesh')
call termcolor#hl('djangoTagBlock', 'orange')
call termcolor#hl('djangoVarBlock', 'orange')
" }}}
" ======== GitCommit ========"{{{
call termcolor#hl('gitcommitSummary', 'orange')
"}}}
" ======== HTML ======== {{{
" Punctuation
call termcolor#hl('htmlTag',    'darkbrown', 'bg', 'none')
call termcolor#hl('htmlEndTag', 'darkbrown', 'bg', 'none')
" Tag names
call termcolor#hl('htmlTagName',        'coffee', '', 'bold')
call termcolor#hl('htmlSpecialTagName', 'coffee', '', 'bold')
call termcolor#hl('htmlSpecialChar',    'yellow1',   '', 'none')

" Attributes
call termcolor#hl('htmlArg', 'coffee', '', 'none')

" Stuff inside an <a> tag
call termcolor#hl('htmlLink', 'gray70', '', 'underline')

" }}}
" ======== JavaScript ========"{{{
call termcolor#hl('javaScriptFuncKeyword', 'deeppurple', '', 'bold')
call termcolor#hl('javaScriptFunction', 'purple', '', 'none')
call termcolor#hl('javaScriptFuncDef', 'orange', '', 'none')
call termcolor#hl('javaScriptFuncExp', 'orange', '', 'none')
call termcolor#hl('javaScriptAjaxMethods', '', '', 'none')
call termcolor#hl('javaScriptBuiltin', 'yellow', '', 'none')
"}}}
" ======== Markdown ======== {{{
call termcolor#hl('markdownHeadingRule', 'gray70', '', 'bold')
call termcolor#hl('markdownHeadingDelimiter', 'gray70', '', 'bold')
call termcolor#hl('markdownOrderedListMarker', 'gray70', '', 'bold')
call termcolor#hl('markdownListMarker', 'gray70', '', 'bold')
call termcolor#hl('markdownItalic', 'front', '', 'bold')
call termcolor#hl('markdownBold', 'front', '', 'bold')
call termcolor#hl('markdownH1', 'yellow', '', 'bold')
call termcolor#hl('markdownH2', 'yellow', '', 'bold')
call termcolor#hl('markdownH3', 'orange', '', 'none')
call termcolor#hl('markdownH4', 'orange', '', 'none')
call termcolor#hl('markdownH5', 'orange', '', 'none')
call termcolor#hl('markdownH6', 'orange', '', 'none')
call termcolor#hl('markdownLinkText', 'lightbrown', '', 'underline')
call termcolor#hl('markdownIdDeclaration', 'lightbrown')
call termcolor#hl('markdownAutomaticLink', 'lightbrown', '', 'bold')
call termcolor#hl('markdownUrl', 'lightbrown', '', 'bold')
call termcolor#hl('markdownUrldelimiter', 'gray70', '', 'bold')
call termcolor#hl('markdownLinkDelimiter', 'gray70', '', 'bold')
call termcolor#hl('markdownLinkTextDelimiter', 'gray70', '', 'bold')
call termcolor#hl('markdownCodeDelimiter', 'flesh', '', 'bold')
call termcolor#hl('markdownCode', 'flesh', '', 'none')
call termcolor#hl('markdownCodeBlock', 'flesh', '', 'none')

" }}}
" ======== Python ======== {{{

hi def link pythonOperator Operator
call termcolor#hl('pythonBuiltin',     'yellow', '', 'none')
call termcolor#hl('pythonBuiltinObj',  'yellow1', '', 'none')
call termcolor#hl('pythonBuiltinFunc', 'pink')
call termcolor#hl('pythonEscape',      'pink')
call termcolor#hl('pythonException',   'red', '', 'bold')
call termcolor#hl('pythonExceptions',  'red', '', 'none')
call termcolor#hl('pythonDecorator',   'red', '', 'none')
call termcolor#hl('pythonRun',         'gray70', '', 'bold')
call termcolor#hl('pythonCoding',      'gray70', '', 'bold')
call termcolor#hl('pythonInclude',     'deeppurple', '', 'bold')

" }}}

"}}}
