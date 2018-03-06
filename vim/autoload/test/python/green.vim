scriptencoding utf-8

if !exists('g:test#python#green#file_pattern')
  let g:test#python#green#file_pattern = '\v^test.*\.py$'
endif

function! test#python#green#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#green#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'green'
    else
      return executable('python')
    endif
  endif
endfunction

function! test#python#green#build_position(type, position) abort
  let path = s:get_import_path(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [path . '.' . name]
    else
      return [path]
    endif
  elseif a:type ==# 'file'
    return [path]
  else
    return []
  endif
endfunction

function! test#python#green#build_args(args) abort
  return a:args + ['--notermcolor']
endfunction

function! test#python#green#executable() abort
  return 'python -m green'
endfunction

function! s:get_import_path(filepath) abort
  " Get path to file from cwd and without extension.
  let path = fnamemodify(a:filepath, ':.:r')
  " Replace the /'s in the file path with .'s
  let path = substitute(path, '\/', '.', 'g')
  return path
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
