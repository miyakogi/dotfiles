scriptencoding utf-8

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=-1
setlocal expandtab

" ======== For matchit ========
" Copied from html.vim
if exists('loaded_matchit')
  let b:match_ignorecase = 1
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif

if exists('loaded_matchit')
  let b:match_words = b:match_words . ',' .
        \ '{{:}},' .
        \ '{%[ -]\?\s*\<block\>\s*\([0-9A-Za-z_]*\)\s*%[ -]\?}:{%[ -]\?\s*\<endblock\>\s*\1\s*[ -]\?%},' .
        \ '{%[ -]\?\s*\<if\>\s\+.*%[ -]\?}:{%[ -]\?\s*\<elif\>\s\+.*[ -]\?%}:{%[ -]\?\s*\<else\>\s*[ -]\?%}:{%[ -]\?\s*\<endif\>\s*[ -]\?%},' .
        \ '{%[ -]\?\s*\<trans\>\s\+.*%[ -]\?}:{%[ -]\?\s*\<pluralize\>\s\+.*[ -]\?%}:{%[ -]\?\s*\<endtrans\>\s*[ -]\?%},' .
        \ '{%[ -]\?\s*\<call\>[0-9A-Za-z_ ()-]\+[ -]\?%}:{%[ -]\?\s*\<endcall\>\s*[ -]\?%},' .
        \ '{%[ -]\?\s*\<\(macro\|for\|filter\|with\|autoescape\)\>[0-9A-Za-z_ ()-]\+[ -]\?%}:{%[ -]\?\s*\<end\1\>\s*[ -]\?%}'
endif
