if type -q difft
  function dt
    difft --display side-by-side-show-both --color always $argv | less -R
  end
end
