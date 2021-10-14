#!/usr/bin/env fish

if not test -f /usr/lib/python3.9/site-packages/virtualfish/virtual.fish
  echo "VirtualFish is not installed. Install by bellow command:"
  echo "paru -S virtualfish"
  exit
end

set -g VIRTUALFISH_VERSION 2.5.1
set -g VIRTUALFISH_PYTHON_EXEC /usr/bin/python

# source /usr/lib/python3.9/site-packages/virtualfish/virtual.fish
# functions defined in the virtual.fish is moved to under functions dir
if not set -q VIRTUALFISH_HOME
  set -g VIRTUALFISH_HOME $HOME/.virtualenvs
end

# 'vf connect' command
# Used by the project management and auto-activation plugins

if not set -q VIRTUALFISH_ACTIVATION_FILE
  set -g VIRTUALFISH_ACTIVATION_FILE .venv
end

if not set -q VIRTUALFISH_GLOBAL_SITE_PACKAGES_FILE
  set -g VIRTUALFISH_GLOBAL_SITE_PACKAGES_FILE "no-global-site-packages.txt"
end

if not set -q VIRTUALFISH_VENV_CONFIG_FILE
  set -g VIRTUALFISH_VENV_CONFIG_FILE "pyvenv.cfg"
end


# load virtualfish plugins
source /usr/lib/python3.9/site-packages/virtualfish/compat_aliases.fish
source /usr/lib/python3.9/site-packages/virtualfish/auto_activation.fish

emit virtualfish_did_setup_plugins
