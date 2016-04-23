if !has('termtruecolor') && !has('gui_running')
    finish
endif

if exists('syntax_on')
    syntax reset
endif
set background=dark
let colors_name = 'trueCaffe'

let s:palette = {
    \ 'front':      ['#fdfafa', 255],
    \ 'back':       ['#1c1c1c', 234],
    \ 'lightblue':  ['#00afff', 39],
    \ 'yellow':     ['#ffd700', 220],
    \ 'yellow1':    ['#ffd75f', 221],
    \ 'orange':     ['#ffb000', 214],
    \ 'lime':       ['#afff00', 154],
    \ 'pink':       ['#ff97bf', 211],
    \ 'flesh':      ['#ffe0b0', 223],
    \ 'lightbrown': ['#af875f', 137],
    \ 'coffee':     ['#d7875f', 173],
    \ 'darkbrown':  ['#875f5f', 95],
    \ 'purple':     ['#ff20a7', 198],
    \ 'deeppurple': ['#da008a', 161],
    \ }

call colors#set_palette(s:palette)

call colors#hl('Normal', 'front', 'back')

call colors#hl('Folded', 'gray6', 'back', 'none')
call colors#hl('VertSplit', 'gray1', 'gray1', 'none')

call colors#hl('CursorLine', '', 'gray1', 'none')
call colors#hl('CursorColumn', '', 'gray1')
call colors#hl('ColorColumn', '', 'gray1')

call colors#hl('TabLine', 'front', 'gray7', 'none')
call colors#hl('TabLineFill', 'front', 'gray7', 'none')
call colors#hl('TabLineSel', 'back', 'lightblue', 'none')

call colors#hl('MatchParen', 'yellow1', 'gray3', 'bold')

call colors#hl('NonText',    'gray5', 'back')
call colors#hl('SpecialKey', 'gray5', 'back')

call colors#hl('Visual', '', 'gray3')
call colors#hl('VisualNOS', '', 'gray3')

call colors#hl('Search',    'back', 'yellow', 'bold')
call colors#hl('IncSearch', 'back', 'lightblue',    'bold')

call colors#hl('Underlined', 'front', '', 'underline')

call colors#hl('StatusLine',   'back', 'lightblue', 'bold')
call colors#hl('StatusLineNC', 'front', 'gray2', 'bold')

call colors#hl('Directory', 'flesh', '', 'bold')

call colors#hl('Title', 'yellow')

call colors#hl('ErrorMsg', 'red', 'back', 'bold')
call colors#hl('MoreMsg', 'yellow', '', 'bold')
call colors#hl('ModeMsg', 'flesh', '', 'bold')
call colors#hl('Question', 'flesh', '', 'bold')
call colors#hl('WarningMsg', 'pink',  '', 'bold')

call colors#hl('IndentGuides', '', 'gray4')
call colors#hl('WildMenu', 'lightblue', 'gray1')

    " Gutter
call colors#hl('LineNr', 'gray6', 'gray2')
call colors#hl('SignColumn', '', 'gray2')
call colors#hl('FoldColumn', 'gray6', 'gray2')

    " Cursor
call colors#hl('Cursor',  'back', 'lightblue', 'bold')
call colors#hl('vCursor', 'back', 'lightblue', 'bold')
call colors#hl('iCursor', 'back', 'lightblue', 'none')

    " Start with a simple base.
call colors#hl('Special', 'front')

    " Comments are slightly brighter than folds, to make 'headers' easier to see.
call colors#hl('Comment',        'gray7')
call colors#hl('Todo',           'front', 'back', 'bold')
call colors#hl('SpecialComment', 'front', 'back', 'bold')

    " Strings are a nice, pale straw color.  Nothing too fancy.
call colors#hl('String', 'flesh')

    " Control flow stuff is red.
call colors#hl('Statement',   'deeppurple', '', 'bold')
call colors#hl('Keyword',     'deeppurple', '', 'bold')
call colors#hl('Conditional', 'deeppurple', '', 'bold')
call colors#hl('Operator',    'purple', '', 'none')
call colors#hl('Label',       'purple', '', 'none')
call colors#hl('Repeat',      'purple', '', 'none')

call colors#hl('Identifier', 'orange', '', 'none')
call colors#hl('Function',   'orange', '', 'none')
call colors#hl('PreProc',   'yellow',  '', 'none')
call colors#hl('Macro',     'yellow',  '', 'none')
call colors#hl('Define',    'yellow',  '', 'none')
call colors#hl('PreCondit', 'yellow',  '', 'bold')

    " Constants of all kinds are colored together.
    " I'm not really happy with the color yet...
call colors#hl('Constant',  'lightbrown', '', 'none')
call colors#hl('Character', 'lightbrown', '', 'bold')
call colors#hl('Boolean',   'lightbrown', '', 'bold')

call colors#hl('Number', 'flesh', '', 'none')
call colors#hl('Float',  'flesh', '', 'none')

    " Not sure what 'special character in a constant' means, but let's make it pop.
call colors#hl('SpecialChar', 'pink', '', 'bold')

call colors#hl('Type', 'pink', '', 'none')
call colors#hl('StorageClass', 'coffee', '', 'none')
call colors#hl('Structure', 'coffee', '', 'none')
call colors#hl('Typedef', 'coffee', '', 'bold')

    " Make try/catch blocks stand out.
call colors#hl('Exception', 'red', '', 'bold')

    " Misc
call colors#hl('Error', 'front', 'red', 'bold')
call colors#hl('Debug', 'front', '', 'bold')
call colors#hl('Ignore', 'gray7')

    " Completion Menu
call colors#hl('Pmenu', 'front', 'gray4')
call colors#hl('PmenuSel', 'back', 'lightblue', 'bold')
call colors#hl('PmenuSbar', '', 'gray4')
call colors#hl('PmenuThumb', 'gray9')

    " Diffs
call colors#hl('DiffDelete', 'back', 'back')
call colors#hl('DiffAdd',    '', 'gray4')
call colors#hl('DiffChange', '', 'gray8')
call colors#hl('DiffText',   'front', 'gray4', 'bold')

    " Spelling {{{
call colors#hl('SpellCap', 'yellow', 'back', 'undercurl,bold', 'yellow')
call colors#hl('SpellBad', '', '', 'undercurl', 'red')
call colors#hl('SpellLocal', '', '', 'undercurl', 'lime')
call colors#hl('SpellRare', '', '', 'undercurl', 'lightblue')
    " }}}

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
call colors#hl('htmlTag',    'darkbrown', 'back', 'none')
call colors#hl('htmlEndTag', 'darkbrown', 'back', 'none')
    " Tag names
call colors#hl('htmlTagName', 'coffee', '', 'bold')
call colors#hl('htmlSpecialTagName', 'coffee', '', 'bold')
call colors#hl('htmlSpecialChar', 'yellow1', '', 'none')

    " Attributes
call colors#hl('htmlArg', 'coffee', '', 'none')

    " Stuff inside an <a> tag
call colors#hl('htmlLink', 'gray7', '', 'underline')

    " }}}
    " ======== JavaScript ========"{{{
call colors#hl('javaScriptFuncKeyword', 'deeppurple', '', 'bold')
call colors#hl('javaScriptFunction', 'purple', '', 'none')
call colors#hl('javaScriptFuncDef', 'orange', '', 'none')
call colors#hl('javaScriptFuncExp', 'orange', '', 'none')
call colors#hl('javaScriptAjaxMethods', '', '', 'none')
call colors#hl('javaScriptBuiltin', 'yellow', '', 'none')
    "}}}
    " ======== Markdown ======== {{{
call colors#hl('markdownHeadingRule', 'gray7', '', 'bold')
call colors#hl('markdownHeadingDelimiter', 'gray7', '', 'bold')
call colors#hl('markdownOrderedListMarker', 'gray7', '', 'bold')
call colors#hl('markdownListMarker', 'gray7', '', 'bold')
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
call colors#hl('markdownUrldelimiter', 'gray7', '', 'bold')
call colors#hl('markdownLinkDelimiter', 'gray7', '', 'bold')
call colors#hl('markdownLinkTextDelimiter', 'gray7', '', 'bold')
call colors#hl('markdownCodeDelimiter', 'flesh', '', 'bold')
call colors#hl('markdownCode', 'flesh', '', 'none')
call colors#hl('markdownCodeBlock', 'flesh', '', 'none')


    " ======== Python ========
call colors#hl('pythonBuiltin',     'yellow', '', 'none')
call colors#hl('pythonBuiltinObj',  'yellow1', '', 'none')
call colors#hl('pythonBuiltinFunc', 'pink')
call colors#hl('pythonEscape',      'pink')
call colors#hl('pythonException',   'red', '', 'bold')
call colors#hl('pythonExceptions',  'red', '', 'none')
call colors#hl('pythonDecorator',   'red', '', 'none')
call colors#hl('pythonRun',         'gray7', '', 'bold')
call colors#hl('pythonCoding',      'gray7', '', 'bold')
call colors#hl('pythonInclude',     'deeppurple', '', 'bold')
