# load local zprofile if exists
if [ -f $HOME/.profile ]; then
  source $HOME/.profile
fi
if [ -f $ZDOTDIR/.zprofile.local ]; then
  source $ZDOTDIR/.zprofile.local
fi
