" =============================================================================
" Version: 0.0
" Author: miyakogi
" License: MIT License
" Last Change: 2016/03/07
" =============================================================================

" This lightline colorscheme is based on jellybeans, which is made by itchyny,
" and is included in lightline.vim.

" =============================================================================
" Filename: autoload/lightline/colorscheme/jellybeans.vim
" Version: 0.0
" Author: itchyny
" License: MIT License
" Last Change: 2013/09/07 12:21:04.
" =============================================================================

" The color-pallet used in this colorscheme is based on badwolf colorscheme,
" which is made by Steve Losh and Contributors.

" =============================================================================
" Copyright (C) 2012 Steve Losh and Contributors
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
" =============================================================================

let s:base03  = [ '#1c1b1a', 232 ]
let s:base02  = [ '#242321', 235 ]
let s:base01  = [ '#45413b', 238 ]
let s:base00  = [ '#666462', 241 ]
let s:base0   = [ '#857f78', 243 ]
let s:base1   = [ '#998f84', 245 ]
let s:base2   = [ '#d9cec3', 252 ]
let s:base3   = [ '#f8f6f2', 15 ]
let s:yellow  = [ '#fade3e', 221 ]
let s:orange  = [ '#ffa724', 214 ]
let s:red     = [ '#ff2c4b', 196 ]
let s:magenta = [ '#ff9eb8', 211 ]
let s:blue    = [ '#0a9dff', 39 ]
let s:cyan    = [ '#8cffba', 121 ]
let s:green   = [ '#aeee00', 154 ]

let s:b = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:b.normal.left     = [ [ s:base02, s:green, 'bold' ], [ s:base3, s:base01 ] ]
let s:b.normal.right    = [ [ s:base02, s:base1 ], [ s:base2, s:base01 ] ]
let s:b.inactive.left   = [ [ s:base0, s:base02, 'bold' ], [ s:base00, s:base02 ] ]
let s:b.inactive.right  = [ [ s:base02, s:base00 ], [ s:base0, s:base02 ] ]
let s:b.insert.left     = [ [ s:base02, s:cyan, 'bold' ], [ s:base3, s:base01 ] ]
let s:b.replace.left    = [ [ s:base02, s:red, 'bold' ], [ s:base3, s:base01 ] ]
let s:b.visual.left     = [ [ s:base02, s:orange, 'bold' ], [ s:base3, s:base01 ] ]
let s:b.normal.middle   = [ [ s:base0, s:base02 ] ]
let s:b.inactive.middle = [ [ s:base00, s:base02 ] ]
let s:b.tabline.left    = [ [ s:base3, s:base00 ] ]
let s:b.tabline.tabsel  = [ [ s:base3, s:base02 ] ]
let s:b.tabline.middle  = [ [ s:base01, s:base1 ] ]
let s:b.tabline.right   = [ [ s:base02, s:base1 ] ]
let s:b.normal.error    = [ [ s:red, s:base02 ] ]
let s:b.normal.warning  = [ [ s:yellow, s:base01 ] ]

let g:lightline#colorscheme#badwolf#palette = lightline#colorscheme#flatten(s:b)
