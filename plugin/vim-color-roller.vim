
" ======== Vim color roller ========
" http://vim-users.jp/2011/09/hack228/P
let ColorRoller = {}
if has('gui_running')
  let ColorRoller.colors = [
        \ 'default',
        \ 'badwolf',
        \ 'jellybeans',
        \ 'lucius_mod',
        \ 'molokai_mod',
        \ 'slateblue',
        \ 'wombat_mod',
        \ 'newspaper',
        \ 'hybrid-light',
        \ 'solarized',
        \ ]
else
  let ColorRoller.colors = [
        \ 'default',
        \ 'badwolf',
        \ 'hybrid',
        \ 'jellybeans',
        \ 'molokai_mod',
        \ 'slateblue',
        \ ]
endif


function! ColorRoller.change()
  let color = get(self.colors, 0)
  " tabpagecolorscheme を使用している場合は↓の "colorscheme" を "Tcolorscheme" に変える。
  if  has('gui_running')
    silent exe "colorscheme " . color
  elseif has('gui') && exists('g:CSApprox_loaded')
    silent execute 'colorscheme ' . color
    silent execute 'CSApprox!'
  elseif  exists('g:loaded_guicolorscheme')
    try
      silent exe "GuiColorScheme " . color
    catch /^Vim\%((\a\+)\)\=:E\d\+/
      silent exe "colorscheme " . color
    endtry
  else
    silent exe "colorscheme " . color
  endif
  redraw
  echo self.colors
endfunction

function! ColorRoller.roll()
  let item = remove(self.colors, 0)
  call insert(self.colors, item, len(self.colors))
  call self.change()
endfunction

function! ColorRoller.unroll()
  let item = remove(self.colors, -1)
  call insert(self.colors, item, 0)
  call self.change()
endfunction

nnoremap <silent><F9>   :<C-u>call ColorRoller.roll()<CR>
nnoremap <silent><S-F9> :<C-u>call ColorRoller.unroll()<CR>
nnoremap <silent><F10> :<C-u>call ColorRoller.unroll()<CR>

