let s:initilized = 0
function! colors#initialize() abort
  let s:spcolor_names = ['NONE', 'bg', 'background', 'fg', 'foreground']
  let s:base_palette = {
      \ 'white':  ['#ffffff', 231],
      \ 'black':  ['#000000', 16],
      \ 'red':    ['#ff0000', 196],
      \ 'green':  ['#00ff00', 46],
      \ 'blue':   ['#0000ff', 21],
      \ 'gray1':  ['#080808', 232],
      \ 'gray2':  ['#121212', 233],
      \ 'gray3':  ['#1c1c1c', 234],
      \ 'gray4':  ['#262626', 235],
      \ 'gray5':  ['#303030', 236],
      \ 'gray6':  ['#3a3a3a', 237],
      \ 'gray7':  ['#444444', 238],
      \ 'gray8':  ['#4e4e4e', 239],
      \ 'gray9':  ['#585858', 240],
      \ 'gray10': ['#626262', 241],
      \ 'gray11': ['#6c6c6c', 242],
      \ 'gray12': ['#767676', 243],
      \ 'gray13': ['#808080', 244],
      \ 'gray14': ['#8a8a8a', 245],
      \ 'gray15': ['#949494', 246],
      \ 'gray16': ['#9e9e9e', 247],
      \ 'gray17': ['#a8a8a8', 248],
      \ 'gray18': ['#b2b2b2', 249],
      \ 'gray19': ['#bcbcbc', 250],
      \ 'gray20': ['#c6c6c6', 251],
      \ 'gray21': ['#d0d0d0', 252],
      \ 'gray22': ['#dadada', 253],
      \ 'gray23': ['#e4e4e4', 254],
      \ 'gray24': ['#eeeeee', 255],
      \ }
  let s:user_palette = {}
  let s:is_term = !has('gui_running')
  let s:truecolor = has('gui_running') || &guicolors
  let s:fg = s:truecolor ? 'guifg=' : 'ctermfg='
  let s:bg = s:truecolor ? 'guibg=' : 'ctermbg='
  let s:attr = has('gui_running') ? 'gui=' : 'cterm='
  let s:initilized = 1
endfunction

function! colors#set_palette(palette) abort
  if !s:initilized | call colors#initialize() | endif
  call extend(s:user_palette, a:palette)
endfunction

function! s:get_color(name) abort
  if index(s:spcolor_names, a:name) >= 0
    return a:name
  else
    return get(s:user_palette, a:name, get(s:base_palette, a:name, ['#000000', 0]))[!s:truecolor]
  endif
endfunction

function! colors#hl(group, ...) abort
  " Arguments: group, fg-color, bg-color, attribute (bold, underline ,...), guisp-color
  let hl = [a:group]
  let fg = a:0 >= 1 ? a:1 : ''
  let bg = a:0 >= 2 ? a:2 : ''
  let attr = a:0 >= 3 ? a:3 : ''
  let guisp = a:0 >= 4 ? a:4 : ''

  if len(fg)
    call add(hl, s:fg . s:get_color(fg))
  endif
  if len(bg)
    call add(hl, s:bg . s:get_color(bg))
  endif
  if len(attr)
    call add(hl, s:attr . attr)
  endif
  if !s:is_term && len(guisp)
    call add(hl, 'guisp=' . s:get_color(guisp))
  endif

  if len(hl) > 1
    " echomsg 'highlight ' . join(hl)
    execute 'highlight ' . join(hl)
  endif
endfunction
