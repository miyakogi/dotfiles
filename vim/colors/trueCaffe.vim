if !has('termguicolors') && !has('gui_running')
    finish
endif

" set background=dark
let g:colors_name = 'trueCaffe'
if exists('syntax_on')
  syntax reset
endif

let s:palette = {
    \ 'front':      ['#f8f6f2', 255],
    \ 'back':       ['#1c1b1a', 234],
    \ 'base03':     ['#1c1b1a', 232],
    \ 'base02':     ['#242321', 235],
    \ 'base01':     ['#45413b', 238],
    \ 'base00':     ['#666462', 241],
    \ 'base0':      ['#857f78', 243],
    \ 'base1':      ['#998f84', 245],
    \ 'base2':      ['#d9cec3', 252],
    \ 'base3':      ['#f8f6f2',  15],
    \ 'lightblue':  ['#00afff',  39],
    \ 'yellow':     ['#ffd700', 220],
    \ 'yellow1':    ['#ffd75f', 221],
    \ 'orange':     ['#ffb000', 214],
    \ 'lime':       ['#afff00', 154],
    \ 'pink':       ['#ff69b4', 211],
    \ 'flesh':      ['#fae3b2',  11],
    \ 'lightbrown': ['#af875f', 137],
    \ 'coffee':     ['#d7875f', 173],
    \ 'darkbrown':  ['#875f5f',  95],
    \ 'purple':     ['#ff20a7', 198],
    \ 'deeppurple': ['#da008a', 161],
    \ }

call colors#set_palette(s:palette)

let s:back = has('gui_running') ? 'back' : 'NONE'
call colors#hl('Normal', 'front', s:back)

" Information (StatusLine & TabLine) {{{
call colors#hl('StatusLine',   'front', 'base01', 'none')  " status line, bold/reverse by default
call colors#hl('StatusLineNC', 'base0', 'base02', 'none')  " status line for no-current windows
call colors#hl('TabLineSel',  '', 'base02', 'none')  " active tab, bolded by default
call colors#hl('TabLine',     '', 'base00', 'none')  " non-active tab, underlined by default 
call colors#hl('TabLineFill', 'base1', 'base1')  " tab-background
"}}}

" Vertical lines are same color as background status line
call colors#hl('VertSplit', 'base01', s:back, 'none')
highlight! link ColorColumn TabLineSel

" Elements on vertical separator
" Order: VertSplit | FoldColumn | SignColumn | LineNr
let s:line_back = has('gui_running') ? 'gray2' : 'NONE'
call colors#hl('LineNr', 'base00', s:line_back)
highlight! link SignColumn LineNr
highlight! link FoldColumn LineNr

call colors#hl('CursorLine', '', 'gray1', 'none')
call colors#hl('CursorColumn', '', 'gray1')

" NonText, Folds, and Comments are gray
call colors#hl('NonText', 'base00', s:back, 'none')
highlight! link SpecialKey NonText
highlight! link Folded NonText
call colors#hl('Comment', 'gray16')  " comments are brighter

call colors#hl('Visual', '', 'base02')
highlight! link VisualNOS Visual

call colors#hl('Search',    'back', 'yellow', 'bold')
call colors#hl('IncSearch', 'back', 'lightblue',    'bold')
call colors#hl('MatchParen', 'yellow1', 'back', 'bold')

call colors#hl('Underlined', '', '', 'underline')  " same as default

call colors#hl('Directory', 'flesh', '', 'bold')

call colors#hl('Title', 'yellow')

call colors#hl('ErrorMsg', 'red', 'back', 'bold')
call colors#hl('MoreMsg', 'yellow', '', 'bold')
call colors#hl('ModeMsg', 'flesh', '', 'bold')
call colors#hl('Question', 'flesh', '', 'bold')
call colors#hl('WarningMsg', 'pink',  '', 'bold')

call colors#hl('IndentGuides', '', 'gray8')
call colors#hl('WildMenu', 'lightblue', 'gray1')

" Cursor
call colors#hl('Cursor',  'back', 'lightblue', 'bold')
" call colors#hl('vCursor', 'back', 'lightblue', 'bold')
highlight! link vCursor Cursor
call colors#hl('iCursor', 'back', 'lightblue', 'none')

" Start with a simple base.
call colors#hl('Special', 'front')

" Comments are slightly brighter than folds, to make 'headers' easier to see.
call colors#hl('Todo',           'front', 'back', 'bold')
call colors#hl('SpecialComment', 'front', 'back', 'bold')

" Strings are a nice, pale straw color.  Nothing too fancy.
call colors#hl('String', 'flesh')
highlight! link Number String
highlight! link Float String
" call colors#hl('Number', 'flesh', '', 'none')
" call colors#hl('Float',  'flesh', '', 'none')

call colors#hl('Identifier', 'orange', '', 'none')
" call colors#hl('Function',   'orange', '', 'none')

" Control flow stuff is red.
call colors#hl('Statement',   'deeppurple', '', 'bold')
" highlight! link Keyword Statement  " linked to Statement by default
" highlight! link Conditional Statement
call colors#hl('Operator',    'purple', '', 'none')
highlight! link Label Operator
highlight! link Repeat Operator
" call colors#hl('Label',       'purple', '', 'none')
" call colors#hl('Repeat',      'purple', '', 'none')

call colors#hl('PreProc',   'yellow',  '', 'none')
" call colors#hl('Macro',     'yellow',  '', 'none')
" call colors#hl('Define',    'yellow',  '', 'none')
call colors#hl('PreCondit', 'yellow',  '', 'bold')

call colors#hl('Constant',  'pink', '', 'none')
call colors#hl('Character', 'lightbrown', '', 'bold')
call colors#hl('Boolean',   'lightbrown', '', 'bold')

" Not sure what 'special character in a constant' means, but let's make it pop.
call colors#hl('SpecialChar', 'pink', '', 'bold')

call colors#hl('Type', 'pink', '', 'none')
call colors#hl('StorageClass', 'purple', '', 'none')
call colors#hl('Structure', 'coffee', '', 'none')
call colors#hl('Typedef', 'coffee', '', 'bold')

" Make try/catch blocks stand out.
call colors#hl('Exception', 'red', '', 'bold')

" Misc
call colors#hl('Error', 'front', 'red', 'bold')
call colors#hl('Debug', 'front', '', 'bold')
call colors#hl('Ignore', 'gray16')

" Completion Menu
call colors#hl('Pmenu', 'front', 'base01')
call colors#hl('PmenuSel', 'back', 'lightblue', 'bold')
call colors#hl('PmenuSbar', '', 'base00')
call colors#hl('PmenuThumb', 'gray16')

" Diffs
call colors#hl('DiffDelete', 'back', 'back')
call colors#hl('DiffAdd',    '', 'base01')
call colors#hl('DiffChange', '', 'black')
call colors#hl('DiffText',   '', 'base01', 'underline')

" Spelling
call colors#hl('SpellCap', '', 'base01', 'undercurl', 'lime')
call colors#hl('SpellBad', '', 'base01', 'undercurl', 'red')
call colors#hl('SpellLocal', '', 'base01', 'undercurl', 'yellow')
call colors#hl('SpellRare', '', 'base01', 'undercurl', 'lightblue')

" ============================================
"  Filetype-specific {{{
" ============================================
" ======== Django ======== {{{
call colors#hl('djangoArgument', 'flesh')
call colors#hl('djangoTagBlock', 'orange')
call colors#hl('djangoVarBlock', 'orange')
" }}}
" ======== GitCommit ========"{{{
call colors#hl('gitcommitSummary', 'orange')
"}}}
" ======== HTML ======== {{{
" Punctuation
call colors#hl('htmlTag',    'darkbrown', '', 'none')
call colors#hl('htmlEndTag', 'darkbrown', '', 'none')
" Tag names
call colors#hl('htmlTagName', 'coffee', '', 'bold')
call colors#hl('htmlSpecialTagName', 'coffee', '', 'bold')
call colors#hl('htmlSpecialChar', 'yellow1', '', 'none')

" Attributes
call colors#hl('htmlArg', 'coffee', '', 'none')

" Stuff inside an <a> tag
call colors#hl('htmlLink', 'gray16', '', 'underline')

" }}}
" ======== JavaScript ========"{{{
call colors#hl('javaScriptFuncKeyword', 'deeppurple', '', 'bold')
call colors#hl('javaScriptFunction', 'purple', '', 'none')
call colors#hl('javaScriptFuncDef', 'orange', '', 'none')
call colors#hl('javaScriptFuncExp', 'orange', '', 'none')
call colors#hl('javaScriptAjaxMethods', '', '', 'none')
call colors#hl('javaScriptBuiltin', 'yellow', '', 'none')
"}}}
" ======== Markdown ======== "{{{
call colors#hl('markdownHeadingRule', 'gray16', '', 'bold')
call colors#hl('markdownHeadingDelimiter', 'gray16', '', 'bold')
call colors#hl('markdownOrderedListMarker', 'gray16', '', 'bold')
call colors#hl('markdownListMarker', 'gray16', '', 'bold')
call colors#hl('markdownItalic', 'front', '', 'bold')
call colors#hl('markdownBold', 'front', '', 'bold')
call colors#hl('markdownH1', 'yellow', '', 'bold')
call colors#hl('markdownH2', 'yellow', '', 'bold')
call colors#hl('markdownH3', 'orange', '', 'none')
call colors#hl('markdownH4', 'orange', '', 'none')
call colors#hl('markdownH5', 'orange', '', 'none')
call colors#hl('markdownH6', 'orange', '', 'none')
call colors#hl('markdownLinkText', 'lightbrown', '', 'underline')
call colors#hl('markdownIdDeclaration', 'lightbrown')
call colors#hl('markdownAutomaticLink', 'lightbrown', '', 'bold')
call colors#hl('markdownUrl', 'lightbrown', '', 'bold')
call colors#hl('markdownUrldelimiter', 'gray16', '', 'bold')
call colors#hl('markdownLinkDelimiter', 'gray16', '', 'bold')
call colors#hl('markdownLinkTextDelimiter', 'gray16', '', 'bold')
call colors#hl('markdownCodeDelimiter', 'flesh', '', 'bold')
call colors#hl('markdownCode', 'flesh', '', 'none')
call colors#hl('markdownCodeBlock', 'flesh', '', 'none')
"}}}
" ======== Python ======== "{{{
call colors#hl('pythonBuiltin',     'yellow', '', 'none')
call colors#hl('pythonBuiltinObj',  'yellow1', '', 'none')
call colors#hl('pythonBuiltinFunc', 'pink')
call colors#hl('pythonEscape',      'pink')
call colors#hl('pythonException',   'red', '', 'bold')
call colors#hl('pythonExceptions',  'red', '', 'none')
call colors#hl('pythonDecorator',   'red', '', 'none')
call colors#hl('pythonRun',         'gray16', '', 'bold')
call colors#hl('pythonCoding',      'gray16', '', 'bold')
call colors#hl('pythonInclude',     'deeppurple', '', 'bold')
"}}}
"}}}
