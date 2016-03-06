" Vim color file
" Name:       h2u_white
" Maintainer: Kyo Nagashima <kyo@hail2u.net>
" URL:        http://hail2u.net/
" Version:    12.4.21
" License:    http://hail2u.mit-license.org/2012

set background=light
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "h2u_white"


" General
" hi ColorColumn
" hi Conceal
hi Cursor        guifg=#ffffff  guibg=#333333  gui=NONE
hi CursorColumn  guifg=NONE     guibg=#ddeeff  gui=NONE
hi CursorIM      guifg=#ffffff  guibg=#ff3333  gui=NONE
hi CursorLine    guifg=NONE     guibg=#ddeeff  gui=NONE
hi CursorLineNr  guifg=#999999  guibg=#ddeeff  gui=NONE
hi Directory     guifg=#6666cc  guibg=NONE     gui=NONE
hi DiffAdd       guifg=NONE     guibg=#6666cc  gui=NONE
hi DiffChange    guifg=NONE     guibg=#9999ff  gui=NONE
hi DiffDelete    guifg=#6666cc  guibg=NONE     gui=NONE
hi DiffText      guifg=NONE     guibg=#cc6666  gui=NONE
hi ErrorMsg      guifg=#ffffff  guibg=#ff3333  gui=NONE
hi VertSplit     guifg=#cccccc  guibg=#eeeeee  gui=NONE
hi Folded        guifg=#9999ff  guibg=#ccddee  gui=NONE
hi FoldColumn    guifg=#6666cc  guibg=#ccddee  gui=NONE
hi SignColumn    guifg=#6666cc  guibg=#ccddee  gui=NONE
hi IncSearch     guifg=#000000  guibg=#ff9933  gui=NONE
hi LineNr        guifg=#999999  guibg=#eeeeee  gui=NONE
hi MatchParen    guifg=#000000  guibg=#ff9933  gui=bold
hi ModeMsg       guifg=#3399ff  guibg=NONE     gui=NONE
hi MoreMsg       guifg=#339933  guibg=NONE     gui=NONE
hi NonText       guifg=#cccccc  guibg=NONE     gui=NONE
hi Normal        guifg=#000000  guibg=#ffffff  gui=NONE
hi Pmenu         guifg=#666666  guibg=#eeeeee  gui=NONE
hi PmenuSel      guifg=#000000  guibg=#ddeeff  gui=NONE
hi PmenuSbar     guifg=#000000  guibg=#ccddee  gui=NONE
hi PmenuThumb    guifg=#000000  guibg=#ddeeff  gui=NONE
hi Question      guifg=#3399ff  guibg=NONE     gui=NONE
hi Search        guifg=#000000  guibg=#ffff00  gui=NONE
hi SpecialKey    guifg=#cccccc  guibg=#ffffff  gui=NONE
hi SpellBad      guifg=NONE     guibg=NONE     gui=undercurl  guisp=#cc3333
hi SpellCap      guifg=NONE     guibg=NONE     gui=undercurl  guisp=#9999ff
hi SpellLocal    guifg=NONE     guibg=NONE     gui=undercurl  guisp=#339933
hi SpellRare     guifg=NONE     guibg=NONE     gui=undercurl  guisp=#cc33cc
hi StatusLine    guifg=#666666  guibg=#ccddee  gui=NONE
hi StatusLineNC  guifg=#999999  guibg=#ccddee  gui=NONE
hi TabLine       guifg=#333333  guibg=#eeeeee  gui=underline
hi TabLineFill   guifg=#333333  guibg=#eeeeee  gui=underline
hi TabLineSel    guifg=#333333  guibg=#ffffff  gui=NONE
hi Title         guifg=#cc6600  guibg=NONE     gui=NONE
hi Visual        guifg=NONE     guibg=#ccddff  gui=NONE
" hi VisualNOS
hi WarningMsg    guifg=#cc6666  guibg=NONE     gui=NONE
hi WildMenu      guifg=#000000  guibg=#3399ff  gui=NONE


" Syntax
hi Comment       guifg=#999999  guibg=NONE     gui=NONE
hi Constant      guifg=#339933  guibg=NONE     gui=NONE
hi Character     guifg=#cc6666  guibg=NONE     gui=NONE
hi Number        guifg=#cc66cc  guibg=NONE     gui=NONE
hi Identifier    guifg=#6666cc  guibg=NONE     gui=NONE
hi Statement     guifg=#3399ff  guibg=NONE     gui=NONE
hi PreProc       guifg=#0066cc  guibg=NONE     gui=NONE
hi Type          guifg=#ff9933  guibg=NONE     gui=NONE
hi Special       guifg=#cc6600  guibg=NONE     gui=NONE
hi Underlined    guifg=NONE     guibg=NONE     gui=underline
" hi Ignore
hi Error         guifg=NONE     guibg=NONE     gui=undercurl  guisp=#ff3333
hi Todo          guifg=#ff3333  guibg=NONE     gui=underline

hi link  Boolean  Character
hi link  Float    Number

" HTML
hi link htmlTag Identifier
