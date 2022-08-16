" Maintainer:            Mr_Glitch projekt.root@tuta.io
" Manjaro forum user:    @Mr_Glitch
" URL:                   https://gitlab.com/ProjektRoot

let g:colors_name = "manjaro_matcha_dark"
set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

set t_Co=256

" WHITE
hi Normal                   ctermfg=254     ctermbg=NONE    cterm=NONE    guifg=#f8f8f8    guibg=NONE       gui=NONE
hi Identifier               ctermfg=254     ctermbg=NONE    cterm=NONE    guifg=#f8f8f8    guibg=NONE       gui=NONE
hi LineNr                   ctermfg=252     ctermbg=NONE    cterm=NONE    guifg=#d0d0d0    guibg=NONE       gui=NONE

" RED
hi ErrorMsg                 ctermfg=254     ctermbg=160     cterm=NONE    guifg=#f2f2f2    guibg=#d42038    gui=NONE
hi WarningMsg               ctermfg=160     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi Exception                ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi Error                    ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi DiffText                 ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi DiffDelete               ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi cssIdentifier            ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi cssImportant             ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE
hi Type                     ctermfg=196     ctermbg=NONE    cterm=NONE    guifg=#d42038    guibg=NONE       gui=NONE

" GREEN
hi Title                    ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eB398    guibg=NONE       gui=NONE
hi String                   ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eB398    guibg=NONE       gui=NONE
hi PMenuSel                 ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi Constant                 ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi PreProc                  ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi Repeat                   ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi DiffAdd                  ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi GitGutterAdd             ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi cssIncludeKeyword        ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi Keyword                  ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi Directory                ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi VertSplit                ctermfg=36      ctermbg=NONE    cterm=NONE    guifg=#2eb398    guibg=NONE       gui=NONE
hi Cursor                   ctermfg=43      ctermbg=236     cterm=NONE    guifg=#19ac90    guibg=#222b2e    gui=NONE
hi CursorIM	                ctermfg=43      ctermbg=236     cterm=NONE    guifg=#19ac90    guibg=#222b2e    gui=NONE
hi CursorLine               ctermfg=254     ctermbg=36      cterm=NONE    guifg=NONE       guibg=#222b2e    gui=NONE
hi StatusLine               ctermfg=255     ctermbg=36      cterm=NONE    guifg=#f2f2f2    guibg=#4f5355    gui=bold
hi StatusLineNC             ctermfg=234     ctermbg=36      cterm=NONE    guifg=#4f5355    guibg=#222b2e    gui=NONE

" YELLOW
hi CursorLineNR             ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi IncSearch                ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi SpecialComment           ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi PreCondit                ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Debug                    ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi SpecialChar              ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Conditional              ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Todo                     ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Special                  ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Delimiter                ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Number                   ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Define                   ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi MoreMsg                  ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Tag                      ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi MatchParen               ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi Macro                    ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi DiffChange               ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi cssColor                 ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi GitGutterDelete          ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi GitGutterChangeDelete    ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE
hi GitGutterChange          ctermfg=221     ctermbg=NONE    cterm=NONE    guifg=#eac358    guibg=NONE       gui=NONE

" Purple
hi markdownLinkText         ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE
hi javaScriptBoolean        ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE
hi Include                  ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE
hi Storage                  ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE
hi cssClassName             ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE
hi cssClassNameDot          ctermfg=135     ctermbg=NONE    cterm=NONE    guifg=#9863ce    guibg=NONE       gui=NONE

" BLUE
hi Statement                ctermfg=111     ctermbg=NONE    cterm=NONE    guifg=#6dc3d5    guibg=NONE       gui=NONE
hi Operator                 ctermfg=111     ctermbg=NONE    cterm=NONE    guifg=#6dc3d5    guibg=NONE       gui=NONE
hi cssAttr                  ctermfg=111     ctermbg=NONE    cterm=NONE    guifg=#6dc3d5    guibg=NONE       gui=NONE
hi Function                 ctermfg=32      ctermbg=NONE    cterm=NONE    guifg=#3b78de    guibg=NONE       gui=NONE
hi Label                    ctermfg=39      ctermbg=NONE    cterm=NONE    guifg=#4f77ba    guibg=NONE       gui=NONE

" GREY LIGHT
hi Pmenu                    ctermfg=255     ctermbg=240     cterm=NONE    guifg=#f2f2f2    guibg=#4f5355    gui=NONE
hi TabLine                  ctermfg=NONE    ctermbg=240     cterm=NONE    guifg=NONE       guibg=#4f5355    gui=NONE
hi Visual                   ctermfg=NONE    ctermbg=240     cterm=NONE    guifg=NONE       guibg=#4f5355    gui=NONE
hi Search                   ctermfg=254     ctermbg=248     cterm=NONE    guifg=#f2f2f2    guibg=#818d90    gui=NONE

" GREY DARK"
hi NonText                  ctermfg=253     ctermbg=NONE    cterm=NONE    guifg=#818d90    guibg=#4f5355    gui=NONE
hi Comment                  ctermfg=246     ctermbg=NONE    cterm=NONE    guifg=#818d90    guibg=NONE       gui=italic
hi CursorColumn             ctermfg=NONE    ctermbg=236     cterm=NONE    guifg=NONE       guibg=#222b2e    gui=NONE
hi ColorColumn              ctermfg=NONE    ctermbg=236     cterm=NONE    guifg=NONE       guibg=#222b2e    gui=NONE

" NONE
hi TabLineFill              ctermfg=NONE    ctermbg=NONE    cterm=NONE    guifg=NONE       guibg=NONE       gui=NONE
