
" ======== Vim color roller ========
" http://vim-users.jp/2011/09/hack228/P
let ColorRoller = {}
let ColorRoller.colors = [
    \ 'default',
    \ 'badwolf',
    \ 'gruvbox',
    \ 'jellybeans',
    \ 'newspaper',
    \ 'onedark',
    \ 'slateblue',
    \ 'solarized',
    \ 'trueCaffe',
    \ 'wombat',
    \ ]


function! ColorRoller.change()
  let color = get(self.colors, 0)
  silent exe "colorscheme " . color
  redraw
  echo color
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
