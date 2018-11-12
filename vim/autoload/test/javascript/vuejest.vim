if !exists('g:test#javascript#jest#file_pattern')
  let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#vuejest#test_file(file) abort
  return a:file =~# g:test#javascript#jest#file_pattern
    \ && test#javascript#has_package('@vue/cli-plugin-unit-jest')
endfunction

function! test#javascript#vuejest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return ['--no-coverage', '--silent', name, '--testPathPattern', a:position['file']]
  elseif a:type ==# 'file'
    return ['--no-coverage', '--silent', '--testPathPattern', a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#vuejest#build_args(args) abort
  return a:args
endfunction

function! test#javascript#vuejest#executable() abort
  return 'npm run test:unit --silent --'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
