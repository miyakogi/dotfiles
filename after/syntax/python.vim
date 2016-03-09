syntax sync fromstart

let s:builtins = [
      \ 'False', 'True', 'None',
      \ 'NotImplemented', 'Ellipsis', '__debug__',
      \ ]

" built-in specails
call extend(s:builtins, [
      \ '__builtins__', '__cached__', '__doc__', '__file__',
      \ '__loader__', '__name__', '__package__', '__path__', '__spec__'
      \ ])

" built-in functions
let s:builtin_func = [
      \ 'abs', 'all', 'any', 'bin', 'callable', 'chr',
      \ 'compile', 'delattr', 'dir',
      \ 'divmod', 'eval', 'format',
      \ 'getattr', 'globals', 'hasattr', 'hash',
      \ 'help', 'hex', 'id', 'input', 'isinstance',
      \ 'issubclass', 'iter', 'len', 'locals', 'max',
      \ 'min', 'next', 'oct', 'open', 'ord', 'pow',
      \ 'print', 'repr', 'reversed', 'round',
      \ 'setattr', 'sorted',
      \ 'sum', 'vars', '__import__',
      \ 'bytes',
      \ ]

let s:builtin_obj = [
      \ 'bool', 'bytearray',
      \ 'classmethod', 'complex', 'dict',
      \ 'enumerate', 'filter', 'float',
      \ 'frozenset',
      \ 'int',
      \ 'list', 'map',
      \ 'memoryview', 'object',
      \ 'property', 'range', 'set',
      \ 'slice', 'staticmethod', 'str',
      \ 'super', 'tuple', 'type', 'zip',
      \ 'bytes',
      \ ]

for k in s:builtins
  exec 'syn match pythonBuiltin /\(\_^\|[^.]\)\zs\<' . k . '\>\ze/'
endfor

for func in s:builtin_func
  exec 'syn match pythonBuiltinFunc /\(\_^\|[^.]\)\zs\<' . func . '\>\ze/'
endfor

for obj in s:builtin_obj
  exec 'syn match pythonBuiltinObj /\(\_^\|[^.]\)\zs\<' . obj . '\>\ze/'
endfor

hi link pythonBuiltinFunc pythonBuiltin
hi link pythonBuiltinObj pythonBuiltin
syn clear pythonStatement
syn keyword pythonStatement	as assert break continue del exec global
syn keyword pythonStatement	lambda nonlocal pass return with yield
syn keyword pythonStatement	class def nextgroup=pythonFunction skipwhite
syn match pythonStatement /\.\.\./
