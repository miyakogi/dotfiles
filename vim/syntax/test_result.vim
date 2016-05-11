
syntax keyword ErrorMsg Failure Error
syntax keyword GreenSkip Skipped

syntax match GreenOK         /\v^\.\s+.*$/
syntax match GreenError      /\v^[EF]\s+.*$/
syntax match GreenSkip       /\v^[sx]\s+.*$/
syntax match GreenXPass      /\v^u\s+.*$/
syntax match GreenErrorLine  /\v^\u.*Error:\ze /

syntax match GreenDotOK      /\v%1l\./
syntax match GreenDotError   /\v%1l[EF]/
syntax match GreenDotSkip    /\v%1l[sx]/
syntax match GreenDotXPass   /\v%1lu/
syntax match GreenNoDot      /\v%1l^test_.*/

syntax match GreenActual     /\v^-\s+.*$/
syntax match GreenExpected   /\v^\+\s+.*$/
syntax match GreenMissMatch  /\v^\?\s+.*$/

syntax match GreenResultOK    /\v^OK\ze \(/
syntax match GreenResultFail  /\v^FAILED\ze \(/

highlight GreenOK    guifg=#aeee00 ctermfg=154
highlight link GreenError ErrorMsg
highlight GreenSkip  guifg=#87afff ctermfg=111
highlight GreenXPass guifg=#ffd700 ctermfg=220
highlight link GreenErrorLine WarningMsg

highlight link GreenDotOK     GreenOK
highlight link GreenDotError  GreenError
highlight link GreenDotSkip   GreenSkip
highlight link GreenDotXPass  GreenXPass

highlight link GreenResultOK   GreenOK
highlight link GreenResultFail GreenError

highlight GreenActual    guifg=#ffa0a0
highlight GreenExpected  guifg=#a0eded
highlight GreenMissMatch guifg=#cccccc
