# Defined in - @ line 1
function path --description 'print simplified path'
  for p in $PATH
    echo $p
  end
end
