if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match PytestPlatform              '\v^(platform(.*))'
syn match PytestTitleDecoration       "\v\={2,}"
syn match PytestTitle                 "\v\s+(test session starts)\s+"
syn match PytestCollecting            "\v(collecting\s+(.*))"
syn match PytestPythonFile            "\v((.*.py\s+))"
syn match PytestFooterFail            "\v\s+((.*)(failed|error) in(.*))\s+"
syn match PytestFooter                "\v\s+((.*)passed in(.*))\s+"
syn match PytestFailures              "\v\s+(FAILURES|ERRORS)\s+"
syn match PytestErrors                "\v^E\s+(.*)"
syn match PytestDelimiter             "\v_{3,}"
syn match PytestFailedTest            "\v_{3,}\s+(.*)\s+_{3,}"
syn match PytestFooterFail2           "\v\s\d+\sfailed"
syn match PytestFooterError           "\v\s\d+\serror"

syn match PytestPassedTestLineStart   "\v^\zstest_.*\.py:\d+:\ze\s.*\sPASSED$"
syn match PytestPassedTestLineEnd     "\vPASSED$"

syn match PytestFailedTestLineStart   "\v^\zstest_.*\.py:\d+:\ze\s.*\s(FAILED|ERROR)$"
syn match PytestFailedTestLineEnd     "\v(FAILED|ERROR)$"


hi def link PytestPythonFile          String
hi def link PytestPlatform            String
hi def link PytestCollecting          String
hi def link PytestTitleDecoration     Comment
hi def link PytestTitle               Statement
hi def link PytestFooterFail          String
hi def link PytestFooter              String
hi def link PytestFailures            Number
hi def link PytestErrors              Number
hi def link PytestDelimiter           Comment
hi def link PytestFailedTest          Comment
hi def link PytestFailedTestLineEnd   ErrorMsg

hi def link PytestPassedTestLineEnd   PytestGreen
hi def link PytestPassedTestLineStart PytestGreen
" hi PytestFailedTestLineEnd guifg=#FF2819 guibg=black ctermfg=124

function! s:hi_update() abort
  hi PytestGreen guifg=#AEEE00 ctermfg=154
  hi PytestFailedTestLineStart guifg=#FF2819 guibg=black ctermfg=124 
  hi PytestFooterFail2 guifg=#FF2819 ctermfg=124                     
endfunction

augroup pytest_syntax
  autocmd!
  autocmd ColorScheme * call s:hi_update()
augroup END

call s:hi_update()


" let b:current_syntax = 'pytestFails'
" syn match PytestQDelimiter            "\v\s+(\=\=\>\>)\s+"
" syn match PytestQLine                 "Line:"
" syn match PytestQPath                 "\v\s+(Path:)\s+"
" syn match PytestQEnds                 "\v\s+(Ends On:)\s+"
"
" hi def link PytestQDelimiter          Comment
" hi def link PytestQLine               String
" hi def link PytestQPath               String
" hi def link PytestQEnds               String

let b:current_syntax = 'pytest_result'
