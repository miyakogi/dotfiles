syntax match CargoHeading    /\v^\s{3,}\u\w{-}\s/
syntax match CargoOK         /\vok(\.|$)/

syntax match CargoError      /error: /
syntax match CargoErrorNum   /\v\[E\d+\]$/
syntax match CargoErrorLine  /error: .*$/  contains=CargoError,CargoErrorNum

highlight CargoHeading    guifg=#72d5a3 ctermfg=10  gui=bold cterm=bold
highlight link CargoOK CargoHeading

highlight CargoError      guifg=#ff0000 ctermfg=196 gui=bold cterm=bold
highlight CargoErrorNum   guifg=#ffa0a0 ctermfg=196 gui=none cterm=none
highlight CargoErrorLine  gui=bold cterm=bold
