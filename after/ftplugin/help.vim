scriptencoding utf-8

if &l:buftype !=# 'help'
  setlocal list
  setlocal tabstop=8
  setlocal shiftwidth=8
  setlocal softtabstop=8
  setlocal noexpandtab
  setlocal textwidth=78

  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
endif
