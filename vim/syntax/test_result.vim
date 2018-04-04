
syntax keyword ErrorMsg Failure Error
syntax keyword GreenSkip Skipped

syntax match GreenErrorLine  /\v^\u.*Error:\ze /

syntax match UnittestErrorLine /\v^ERROR\ze: .+\)$/
syntax match UnittestFailLine /\v^FAIL\ze: .+\)$/

syntax match GreenOK      /\v\.+/ contained
syntax match GreenError   /\vE+/  contained
syntax match GreenFailure /\vF+/  contained
syntax match GreenSkip    /\vs+/  contained
syntax match GreenSkipX   /\vx+/  contained
syntax match GreenXPass   /\vu+/  contained

syntax match DotLine         /\v^[.EFxsu]+$/  contains=GreenOK,GreenError,GreenFailure,GreenSkip,GreenSkipX,GreenXPass

syntax match GreenActual     /\v^-\s+.*$/
syntax match GreenExpected   /\v^\+\s+.*$/
syntax match GreenMissMatch  /\v^\?\s+.*$/

syntax match TestSeparator   /\v^\=+$/
syntax match TestSeparatorBold   /\v^\-+$/

syntax match GreenResultOK    /\v^OK/
syntax match GreenResultFail  /\v^FAILED/

highlight TestFailure guifg=#ff0000 ctermfg=15 gui=bold cterm=bold

highlight GreenOK    guifg=#aeee00 ctermfg=154
highlight link GreenError TestFailure
highlight link GreenFailure TestFailure
highlight GreenSkip  guifg=#87afff ctermfg=111
highlight link GreenSkipX GreenSkip
highlight GreenXPass guifg=#ffd700 ctermfg=220
highlight link GreenErrorLine WarningMsg

highlight link UnittestErrorLine TestFailure
highlight link UnittestFailLine TestFailure

highlight link GreenDotOK     GreenOK
highlight link GreenDotError  GreenError
highlight link GreenDotSkip   GreenSkip
highlight link GreenDotXPass  GreenXPass

highlight link TestSeparator TestFailure
highlight TestSeparatorBold guifg=#777777

highlight link GreenResultOK   GreenOK
highlight link GreenResultFail GreenError

highlight GreenActual    guifg=#ffa0a0
highlight GreenExpected  guifg=#a0eded
highlight GreenMissMatch guifg=#cccccc
