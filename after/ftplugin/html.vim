scriptencoding utf-8

if &filetype != 'markdown'
  setlocal tabstop=2
  setlocal shiftwidth=2
  setlocal softtabstop=-1
  setlocal expandtab
  syntax sync fromstart
endif

function! HTMLOpenBrowser()
  let filepath = expand('%:p')
  if has('win32')
    return
  elseif has('mac')
    let browser = 'open'
  else
    let browser = 'chromium-browser'
  endif
  let cmd = browser . ' file://' . filepath
  call vimproc#system_bg(cmd)
endfunction

command! HTMLOpenBrowser call HTMLOpenBrowser()
