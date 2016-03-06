" Vim color file
" Name:       slateblue
" Maintainer: miyakogi (https://githuub.com/miyakogi)
" URL:        https://github.com/miyakogi/slateblue.vim
" Version:    1.0.0 
" LastChange: 2014.01.26

" This colorscheme is based on 'slate' colorscheme.
" Original 'slate' colorscheme is included in Vim by default.

set background=dark
highlight clear
if version > 580
 hi clear
 if exists("syntax_on")
 syntax reset
 endif
endif

let colors_name = "slateblueterm"

hi SpecialKey      term=bold ctermfg=238 guifg=grey25
hi NonText         term=bold cterm=bold ctermfg=240 gui=bold guifg=grey35
hi Directory       term=bold ctermfg=159 guifg=PaleTurquoise
hi ErrorMsg        term=standout cterm=bold ctermfg=231 ctermbg=160 gui=bold guifg=#fefefe guibg=#cc0000
hi IncSearch       term=reverse cterm=bold ctermfg=16 ctermbg=230 gui=bold guifg=#000000 guibg=#FFFACD
hi Search          term=reverse cterm=bold ctermfg=230 ctermbg=238 gui=bold guifg=#FFFACD guibg=grey25
hi MoreMsg         term=bold cterm=bold ctermfg=29 gui=bold guifg=SeaGreen
hi ModeMsg         term=bold cterm=bold ctermfg=178 gui=bold guifg=goldenrod
hi LineNr          term=underline ctermfg=244 ctermbg=234 guifg=grey50 guibg=grey11
hi Question        term=standout cterm=bold ctermfg=48 gui=bold guifg=springgreen
hi StatusLine      term=bold,reverse ctermfg=244 ctermbg=233 guifg=grey50 guibg=grey8
hi StatusLineNC    term=reverse ctermfg=241 ctermbg=233 guifg=grey40 guibg=grey8
hi VertSplit       term=reverse cterm=reverse ctermfg=16 ctermbg=16 gui=reverse guifg=#000000 guibg=#000000
hi Title           term=bold cterm=bold ctermfg=220 gui=bold guifg=gold
hi Visual          term=reverse cterm=underline ctermfg=189 ctermbg=233 gui=underline guifg=#ccccee guibg=#101010
hi VisualNOS       term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg      term=standout ctermfg=209 guifg=salmon
hi WildMenu        term=standout ctermfg=231 ctermbg=16 guifg=snow guibg=grey0
hi Folded          term=standout ctermfg=241 ctermbg=16 guifg=grey40 guibg=black
hi FoldColumn      term=standout ctermfg=236 ctermbg=16 guifg=grey20 guibg=black
hi DiffAdd         term=bold ctermbg=23 guibg=#103333
hi DiffChange      term=bold ctermbg=16 guibg=#080818
hi DiffDelete      term=bold cterm=bold ctermfg=21 ctermbg=16 gui=bold guifg=Blue guibg=#2E0808
hi DiffText        term=reverse cterm=bold ctermbg=59 gui=bold guibg=#4C4745
hi SignColumn      term=standout ctermfg=231 ctermbg=233 guifg=snow guibg=grey8
hi Conceal         ctermfg=252 ctermbg=248 guifg=LightGrey guibg=DarkGrey
hi SpellBad        term=reverse cterm=undercurl ctermfg=202 gui=undercurl guisp=#ff3300
hi SpellCap        term=reverse cterm=undercurl ctermfg=48 gui=undercurl guisp=#00ff9a
hi SpellRare       term=reverse cterm=undercurl ctermfg=201 gui=undercurl guisp=Magenta
hi SpellLocal      term=underline cterm=undercurl ctermfg=51 gui=undercurl guisp=Cyan
hi Pmenu           ctermfg=231 ctermbg=59 guifg=#ffffff guibg=#606060
hi PmenuSel        ctermfg=233 ctermbg=255 guifg=#101010 guibg=#eeeeee
hi PmenuSbar       ctermbg=250 guibg=Grey
hi PmenuThumb      ctermbg=231 guibg=White
hi TabLine         term=reverse ctermfg=246 ctermbg=236 guifg=grey60 guibg=#303030
hi TabLineSel      term=bold ctermfg=254 ctermbg=237 guifg=grey88 guibg=grey24
hi TabLineFill     term=reverse cterm=reverse ctermfg=247 ctermbg=236 gui=reverse guifg=#303030 guibg=#9e9e9e
hi CursorColumn    term=reverse ctermbg=234 guibg=#181818
hi ColorColumn     term=reverse ctermbg=238 guibg=grey25
hi Cursor          ctermfg=16 ctermbg=231 guifg=#000000 guibg=#F8F8F0
hi lCursor         ctermfg=235 ctermbg=231 guifg=bg guibg=fg
hi MatchParen      term=reverse ctermbg=30 guibg=DarkCyan
hi Normal          ctermfg=231 ctermbg=235 guifg=snow guibg=grey14
hi Comment         term=bold ctermfg=244 guifg=grey50
hi Constant        term=underline ctermfg=217 guifg=#ffa0a0
hi Special         term=bold ctermfg=230 guifg=#FFFACD
hi Identifier      term=underline ctermfg=209 guifg=salmon
hi Statement       term=bold cterm=bold ctermfg=69 gui=bold guifg=CornflowerBlue
hi PreProc         term=underline ctermfg=159 guifg=PaleTurquoise
hi Type            term=underline cterm=bold ctermfg=117 gui=bold guifg=#8ac6f2
hi Underlined      term=underline cterm=underline ctermfg=111 gui=underline guifg=#80a0ff
hi Ignore          ctermfg=241 guifg=grey40
hi Error           term=reverse ctermfg=231 ctermbg=196 guifg=White guibg=Red
hi Todo            term=standout ctermfg=202 ctermbg=226 guifg=orangered guibg=yellow2
hi String          ctermfg=116 guifg=SkyBlue
hi link Character       Constant
hi link Number          Constant
hi link Boolean         Constant
hi link Float           Number
hi Function        ctermfg=223 guifg=navajowhite
hi link Conditional     Statement
hi link Repeat          Statement
hi link Label           Statement
hi Operator        ctermfg=196 guifg=Red
hi link Keyword         Statement
hi link Exception       Statement
hi Include         ctermfg=196 guifg=red
hi Define          cterm=bold ctermfg=220 gui=bold guifg=gold
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi Structure       ctermfg=46 guifg=green
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link Delimiter       Special
hi link SpecialComment  Special
hi link Debug           Special
hi IndentGuidesOdd  ctermfg=233 ctermbg=233 guifg=grey8 guibg=grey8
hi IndentGuidesEven  ctermfg=234 ctermbg=234 guifg=grey11 guibg=grey11
hi SpellErrors     ctermfg=231 ctermbg=196 guifg=White guibg=Red
hi MatchError      ctermfg=231 ctermbg=160 guifg=white guibg=#dd2211

hi IndentGuidesOdd  ctermbg=233 guibg=grey8
hi IndentGuidesEven ctermbg=234 guibg=grey11

hi treeCWD         ctermfg=231 guifg=#ffffff
hi treeClosable    ctermfg=174 guifg=#df8787
hi treeOpenable    ctermfg=150 guifg=#afdf87
hi treePart        ctermfg=244 guifg=#808080
hi treeDirSlash    ctermfg=159 guifg=PaleTurquoise
hi treeLink        ctermfg=182 guifg=#dfafdf
