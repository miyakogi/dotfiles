" LaTeX filetype
" "   Language: LaTeX (ft=tex)

" TODO: Add function to be directlly called from outside script.
" TODO: Add <Plug> mapping.
" TODO: Split to autoloads.
" TODO: Change TeXCompile class to script local.
" TODO: Use a buffer local variable to call TeXCompile.
" TODO: Add did_loaded check.
" TODO: (if possible) Compile only when files are modified.

" OS check
if has('win32')
  let s:ostype = "Win"
elseif has('mac')
  let s:ostype = "Mac"
else
  if executable('uname')
    let s:ostype = system("uname")
    if match(s:ostype, '[lL]inux') != -1
      let s:ostype = 'Linux'
    else
      let s:ostype = 'OtherOS'
    endif
  else
    let s:ostype = 'OtherOS'
  endif
endif

function! s:define(param, default)
  if exists(a:param)
    return a:param
  else
    if type(a:default) <= 1
      return a:default
    elseif type(a:default) == 4
      if s:ostype == 'Win' && has_key(a:default, 'Win')
        return a:default['Win']
      elseif s:ostype == 'Mac' && has_key(a:default, 'Mac')
        return a:default['Mac']
      elseif s:ostype == 'Linux' && has_key(a:default, 'Linux')
        return a:default['Linux']
      elseif has_key(a:default, 'OtherOS')
        return a:default['OtherOS']
      elseif has_key(a:default, 'Linux')
        return a:default['Linux']
      else
        echoerr 'No OS match'
      endif
    else
      echomsg 'Invalid type of default value (should be number, string or dictionary)'
    endif
  endif
endfunction

" Create main dictionary
let TeXCompile = {'initialized': 0}

let s:vim_path = s:define('g:TeXVimPath',
      \{'Win': "C:\\Users\\aralab\\Documents\\Applications\\vim\\gvim.exe",
      \ 'Mac': "/Applications/Macvim/Contents/macvim.app",
      \ 'Linux': "gvim"})

function! TeXCompile.initialize()
  " Define base .tex file path
  let self.filepath = expand('%:p')
  let self.basedir = expand('%:p:h')
  let self.basename = expand('%:p:t:r')

  " Define latex compile commands
  let cmd = executable('platex') ? 'platex' : executable('latex') ? 'latex' : 'tex'
  let self.latex_cmd = s:define("g:latexcmd", cmd)
  let self.latex_opt = s:define('g:latexopt', '-src -shell-escape -synctex=1 -kanji=utf8')

  let cmd = executable('pbibtex') ? 'pbibtex' : 'bibtex'
  let self.bibtex_cmd = s:define('g:bibtexcmd', cmd)
  let self.bibtex_opt = s:define('g:bibtexopt', '-kanji=utf8')

  let self.dvi2pdf = s:define('g:dvi2pdf', 'dvipdfmx')
  let self.dvi_open = s:define('g:dvicmd', {'Win': 'dviout', 'Mac': 'open', 'Linux': 'okular' })
  " let self.dvi_open_opt = s:define('g:dvicmd',
  "       \{'Win': 'sumatrapdf_sync',
  "       \ 'Mac': '/Applications/Skim.app/Contents/SharedSupport/displayline',
  "       \ 'Linux': 'okular -unique' })

  " Define PDF open commands
  let self.pdf_open = s:define('g:pdfcmd',
        \{'Win': 'sumatrapdf_sync',
        \ 'Mac': '/Applications/Skim.app/Contents/SharedSupport/displayline',
        \ 'Linux': 'okular --unique --noraise' })
  " let self.pdf_open_opt = s:define('g:pdfcmd',
  "       \{'Win': 'sumatrapdf_sync',
  "       \ 'Mac': '/Applications/Skim.app/Contents/SharedSupport/displayline',
  "       \ 'Linux': 'okular -unique' })

  " Set compile commands in each OS
  let self.tex2dvi = self.latex_cmd . " " . self.latex_opt
  let self.bibtex = self.bibtex_cmd . " " . self.bibtex_opt

  " output log file when compile tex to dvi
  let self.jobname = self.basename
  let self.logfile = 'compile.log'
  " TODO: output to a variable and show it in buffer

  let self.initialized = 1
endfunction

function! TeXCompile.init()
  if !self.initialized
    call self.initialize()
  endif
endfunction

"""" Main Functions """"
function! TeXCompile.t2d()
  call self.init()

  execute "lcd " . self.basedir
  let s:execcmd = self.tex2dvi . ' ' . self.filepath
  let s:execcmd = s:execcmd . ' > ' . self.logfile

  echomsg "  $ " . s:execcmd
  let s:stdout = vimproc#system(s:execcmd)
  let s:stdoutlist = split(s:stdout, "\n")

  let s:warningcount = 0
  let s:errorcount = 0
  let s:error_view = 0
  let s:error_msg = "  [Error] "

  for s:line in s:stdoutlist

    let s:warning = stridx(s:line, "Warning")
    if s:warning != -1
      let s:warningcount = s:warningcount + 1
    endif

    let s:error = stridx(s:line, "Error")
    let s:missing = stridx(s:line, "Missing")
    if s:error != -1 || s:missing != -1
      let s:errorcount = s:errorcount + 1
      let s:error_view = 5
    endif
    if s:error_view > 1
      let s:error_msg = s:error_msg . substitute(s:line, "\\s\\s\\+", "","g")
      " echo "  [Error]  " . s:line
      let s:error_view = s:error_view -1
    elseif s:error_view == 1
      let s:error_msg = s:error_msg . substitute(s:line, "\\s\\s\\+", "","g")
      let s:error_view = s:error_view -1
      let ermsg = s:error_msg
      echo ermsg
      let g:errormsg = s:error_msg
      let s:error_msg = "  [Error] "
    endif
  endfor

  echo "  [Result] Error: " . s:errorcount . ", Warning: " . s:warningcount "\n"

endfunction

function! TeXCompile.bib()
  call self.init()
  execute "lcd " . self.basedir
  let l:auxfilelist = glob("*.aux")
  " let self.auxfiles = substitute(l:auxfilelist, "\n", ", ", "g")

  let l:auxfiles = split(l:auxfilelist, "\n")
  let l:_ = s:ostype == 'Win' ? "cd /d " : "cd "
  let s:execcmd = l:_ . self.basedir

  let l:succeed_files = ""
  let l:errorlist = ""

  for l:auxfile in l:auxfiles
    let s:execcmd = self.bibtex . ' ' . l:auxfile
    let l:stdout = vimproc#system(s:execcmd)

    " echo "  " . s:execcmd
    if stridx(l:stdout, "error") == -1
      let l:succeed_files = l:succeed_files . l:auxfile . ", "
    else
      let l:errorlist = l:errorlist . l:auxfile . ", "
    endif
  endfor
  echo "  [Result] Succeeded: " . l:succeed_files
  echo "              Failed: " . l:errorlist
endfunction

function! TeXCompile.d2p()
  call self.init()
  let self.runStr = self.dvi2pdf . ' ' . self.basename
  execute "lcd " . self.basedir
  let s:execcmd = self.dvi2pdf . ' ' . self.basename
  echo "  $ " . s:execcmd . "\n\n"
  let s:execcmd = s:execcmd . ' > ' . self.logfile
  let s:stdout = vimproc#system(s:execcmd)
  echo "  " . s:stdout
endfunction

function! TeXCompile.all()
  call self.init()
  execute "lcd " . self.basedir
  echo   " --- 1. platex (tex -> dvi) --- "
  call self.t2d()
  echo "\n --- 2. pbibtex (aux -> bbl) --- "
  call self.bib()
  echo "\n --- 3. platex (tex -> dvi) --- "
  call self.t2d()
  echo "\n --- 4. platex (tex -> dvi) --- "
  call self.t2d()
  echo "\n --- 5. dvipdfmx (dvi -> pdf) --- "
  call self.d2p()
  echo "\n +-----------------------------------+\n |   Complete TeX - PDF conversion   |\n +-----------------------------------+\n"
endfunction

function! TeXCompile.log()
  call self.init()
  execute "lcd " . self.basedir
  execute 'new +set\ filetype=latexlog\ readonly '. self.basename . '.log'
  execute '6wincmd _'
  execute 'nnoremap <buffer> q <C-w>c'
  call search("Warning")
  " TODO: At first Search Error, and then search Warning. If error exists, do not jump to warning.
  " TODO: Use syntax highlighting for Error/Warning lines.
  " TODO: Add mapping to jump to next/prev. error or warning. ([e, ]e, [w, ]w)
  " TODO: Use quickfix/location list.
endfunction

function! TeXCompile.dviView()
  call self.init()
  if s:ostype == 'Win'
    let self.runStr = self.dvi_open . " " . self.basename . ' "# ' . line(".") . " " . self.basename . '.tex" '
    execute "lcd " . self.basedir
    call vimproc#system_bg(self.runStr)
  elseif s:ostype =='Mac'
    let self.runStr = self.pdf_open . " " . line(".") . " " . self.basename . '.pdf ' . self.basename . '.tex '
    execute "lcd " . self.basedir
    call vimproc#system_bg(self.runStr)
  else
    " let self.runStr = self.pdf_open . ' ' . expand('%<') . '.pdf#src:' . line(".") . "" . expand('%<') . '.tex &'
    " call vimproc#system_bg(self.runStr)
    let self.runStr = self.dvi_open . ' %:p:r.dvi\\#src:' . line(".") . '%:p' . ' &'
    execute "lcd " . self.basedir
    exec "silent! !" . self.runStr
    "   Inverse Search Option in Okular: gvim -remote-silent +%l %f   "
  endif
  echo self.runStr
endfunction

function! TeXCompile.pdfView()
  call self.init()
  execute "lcd " . self.basedir
  if s:ostype == 'Win'
    let self.runStr = self.pdf_open . " " . self.basename . '.pdf ' . self.basename . '.tex ' . line(".")
    call vimproc#system_bg(self.runStr)
    " Back focus to gvim
    let vimmode = g:TeXVimPath . " -n --remote-silent +" . line('.') . " " . self.basename
    call system(vimmode)
  elseif s:ostype == 'Mac'
    let self.runStr = self.pdf_open . " " . line(".") . " " . self.basename . '.pdf ' . self.basename . '.tex &'
    call system(self.runStr)
    " Back focus to gvim
    call system("osascript -e 'tell application \"macvim\" to activate'")
  else
    if executable('zathura')
      if !exists('b:pdf_zathura_p')
        let back_sync = has('gui_running') ?
              \ '-x "gvim --servername=GVIM --remote-silent +%{line} %{input}"'
              \ : ''
        let cmd1 = 'zathura ' . back_sync . ' "' . expand('%:p:r') . '.pdf"'
        let b:pdf_zathura_p = vimproc#popen2(cmd1)
      else
        let pid = b:pdf_zathura_p.pid
        let cmd2 = 'zathura --synctex-pid=' . pid . ' --synctex-forward '  .
              \ line('.') . ':' . col('.') . ':' . expand('%:p') . ' ' . expand('%:p:r') . '.pdf'
        call vimproc#system(cmd2)
      endif
    else
      let self.runStr = self.pdf_open . ' ' . expand('%:p:r') . '.pdf#src:' . line(".") . expand('%:p') . ' &'
      call system(self.runStr)
    endif
  endif
endfunction

" vim set\ fdm=marker\ ts=2\ sts=2\ sw=2\ tw=0\ et
