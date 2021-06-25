# Git setup

if ! git config --get user.email > /dev/null ; then
  read -p 'Enter git config user.email: ' email
  git config --global user.email "$email"
fi
git config --global user.name "Andrew Marino"
git config --global core.editor "vim"
