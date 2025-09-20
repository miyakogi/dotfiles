#!/usr/bin/env fish

status --is-login; and begin
  ### Profile

  # XDG Data bin
  fish_add_path --global "$HOME/.local/bin"

  # Golang
  export GOPATH="$HOME/.go"

  # Rust
  fish_add_path --global "$HOME/.cargo/bin"
  if type -q rustc
    export RUST_SRC_PATH="(rustc --print sysroot)/lib/rustlib/src/rust/src"
  end
  if type -q sccache
    export RUSTC_WRAPPER=(which sccache)
  end

  # User Bin
  fish_add_path --global --move "$HOME/bin"

  # set default programs as nvim
  if type -q nvim
    export EDITOR=nvim
    export MANPAGER="nvim +Man! -u $HOME/.config/nvim/manrc"
  else if type -q vim
    export EDITOR=vim
  end

  # Set less
  export LESS="-iFRS"
  export SYSTEMD_LESS="iFRSM"

  ### Login
  if test -z "$DISPLAY"; and test "$XDG_VTNR" = 1; and begin test -z "$XDG_SESSION_TYPE"; or test "$XDG_SESSION_TYPE" = tty; end
    echo -e -n "\
Select Window Manager or Shell:
> 1) Hyprland [default]
  2) Niri
  3) bash
  4) fish
  5) exit
  *) any executable
"
    read -P '>>> ' choice

    # set default wm candidate
    if test -z "$choice"
      set choice 1
    end

    switch "$choice"
      case 1 "[Hh]pr*"
        set wm "Hyprland"
      case 2 "[Nn]iri"
        set wm "niri"
      case 3 bash sh
        exec bash
      case 4 fish
        exec fish
      case 5
        exit 0
      case '*'
        set wm "$choice"
    end

    if ! command -q uwsm
      export GTK_THEME=Adwaita:dark
      export GTK_USE_PORTAL=1

      export QT_QPA_PLATFORMTHEME=qt6ct

      export XMODIFIERS=@im=fcitx
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export GLFW_IM_MODULE=fcitx

      export GST_VAAPI_ALL_DRIVERS=1

      # hyprland
      export AQ_NO_MODIFIERS=0

      # sway
      export WLR_DRM_NO_MODIFIERS=1
      export XCURSOR_THEME='Vimix cursors'
      export XCURSOR_SIZE=26
    end

    # Start wayland session
    if string match -r -q '(Hyprland|sway|river|niri|weston)' "$wm"
      wm-start $wm
    else
      wm-start $wm
    end
  end
end

status --is-interactive; and begin

  # ls color setting
  set -x LSCOLORS Exfxcxdxbxegedabagacad
  set -x LS_COLORS 'di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

  set -x GPG_TTY (tty)

  # set fzf search command
  if type -q fzf
    set -x FZF_DEFAULT_COMMAND "fd || find ."
    set -x FZF_DEFAULT_OPTS "--exact"
    set _search_cmd "fzf --tac --no-sort --reverse --exact --tiebreak index --ansi --prompt 'fzf> ' --margin 2% --query (commandline -b)"
  end

  # auto ls on cd
  function __auto_ls --on-variable PWD; ls; end

  # zk note taking directory
  set -x ZK_NOTEBOOK_DIR $HOME/Documents/notes/main

  # prompt
  if type -q starship; and begin; test -n "$DISPLAY"; or test -n "$WAYLAND_DISPLAY"; or test -z "$XDG_VTNR"; end
    starship init fish | source
  else
    set -g fish_prompt_pwd_dir_length 0
    function fish_prompt
      printf '[%s] (fish)\n$ ' (prompt_pwd)
    end
  end

  # direnv
  if type -q direnv
    direnv hook fish | source
  end

  # autin command history
  if type -q atuin
    atuin init fish --disable-up-arrow | source
  end

  # zoxide smarter `cd`
  if type -q zoxide
    set -x _ZO_FZF_OPTS "--bind=ctrl-z:ignore --exit-0 --height=40% --info=inline --no-sort --reverse --select-1 --exact"
    zoxide init fish --cmd j | source
  end

  if type -q macchina
    if string match -q "*ghostty" $TERM
      sleep 0.01
    end
    macchina
  end

  # load machine local setting (~/.config/fish/local.fish)
  if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
  end
end
