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
  fish_add_path --global "$HOME/bin"
  fish_add_path --global --move "$HOME/bin"

  # set default programs as nvim
  if type -q nvim
    export EDITOR=nvim
    export MANPAGER="nvim +Man! -u $HOME/.config/nvim/manrc"
  else if type -q vim
    export EDITOR=vim
  end

  # set default pager
  if type -q moar
    export PAGER="moar"
    export GIT_PAGER="moar"
    export MANPAGER="moar"
  end

  # Set less
  export LESS="-iFRS"
  export SYSTEMD_LESS="iFRSM"

  ### Login
  if test -z "$DISPLAY"; and test "$XDG_VTNR" -eq 1; and begin test -z "$XDG_SESSION_TYPE"; or test "$XDG_SESSION_TYPE" = tty; end
    echo -e -n "\
Select Window Manager or Shell:
> 1) Hyprland [default]
  2) Sway
  3) bash
  4) fish
  5) exit
  *) any executable"
    read -P '>>> ' choice

    # set default wm candidate
    if test -z "$choice"
      set choice 1
    end

    switch "$choice"
      case 1 "[Hh]pr*"
        set wm "Hyprland"
      case 2 "[Ss]way"
        set wm "sway"
      case 3 bash sh
        exec bash
      case 4 fish
        exec fish
      case 5
        exit 0
      case '*'
        set wm "$choice"
    end

    # GTK
    export GTK_THEME=Adwaita:dark

    # QT
    # export QT_STYLE_OVERRIDE=qt6ct
    export QT_QPA_PLATFORMTHEME=qt6ct

    # input methods
    export XMODIFIERS=@im=fcitx
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export GLFW_IM_MODULE=fcitx

    # Start wayland session
    if string match -r -q '(Hyprland|sway|river|niri|weston)' "$wm"
      export XDG_SESSION_TYPE=wayland
      export QT_QPA_PLATFORM="wayland;xcb"
      export MOZ_ENABLE_WAYLAND=1
      export GST_VAAPI_ALL_DRIVERS=1

      export XDG_CURRENT_DESKTOP="$wm"
      export XDG_SESSION_DESKTOP="$wm"
      systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP

      # wlroots
      export WLR_DRM_NO_MODIFIERS=1
      export XCURSOR_THEME='Vimix cursors'
      export XCURSOR_SIZE=26
      export GTK_USE_PORTAL=1

      # aquamarine
      # export AQ_NO_MODIFIERS=1

      if [ "$wm" = "niri" ]
        exec niri-session
      else
        exec "$wm"
      end
    else
      exec "$wm"
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

  # show machine info
  if type -q macchina
    function fish_greeting
      if test -n "$DISPLAY"; or test -n "$WAYLAND_DISPLAY"
        macchina
      else
        macchina --theme Simple
      end
    end
  end

  # load machine local setting (~/.config/fish/local.fish)
  if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
  end
end
