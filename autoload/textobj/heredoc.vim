" ======== snigel/double quote in multi-line ========
function! s:select_heredoc(start, end, inner)
  let current_pos = getpos('.')
  let found_start = search(a:start, a:inner ? 'bce' : 'bc')

  " quote not found. go back cursol.
  if found_start == 0
    call setpos('.', current_pos)
    return 0
  endif

  if a:inner
    " execute "normal! \<Right>"
    call search('\S')
    let start_pos = getpos('.')
  else
    let start_pos = getpos('.')
    call search(a:start, 'ce')
    execute "normal! \<Right>"
  endif

  let found_end = search(a:end, a:inner ? 'c' : 'ce')
  if found_end == 0
    call setpos('.', current_pos)
    return 0
  endif

  if a:inner
    call search('\S', 'b')
  endif
  let end_pos = getpos('.')

  return ['v', start_pos, end_pos]
endfunction

function! textobj#heredoc#select_a()
  let start_pattern = get(b:, 'heredoc_start_pattern', 0)
  let end_pattern = get(b:, 'heredoc_end_pattern', 0)
  if (start_pattern ==# '' || end_pattern ==# '')
    return 0
  else
    return s:select_heredoc(start_pattern, end_pattern, 0)
  endif
endfunction

function! textobj#heredoc#select_i()
  let start_pattern = get(b:, 'heredoc_start_pattern', '')
  let end_pattern = get(b:, 'heredoc_end_pattern', '')
  if (start_pattern ==# '' || end_pattern ==# '')
    return 0
  else
    return s:select_heredoc(start_pattern, end_pattern, 1)
  endif
endfunction
