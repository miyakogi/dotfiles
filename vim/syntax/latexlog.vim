if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'nose_result'
endif

syntax match warning /^.*Warning.*$/

" highlight warning ctermfg=DarkYellow guibg=#aacc00 guifg=#000000
highlight link warning Error

"unlet b:current_syntax
let b:current_syntax = 'nose_result'

if main_syntax == 'nose_result'
  unlet main_syntax
endif
