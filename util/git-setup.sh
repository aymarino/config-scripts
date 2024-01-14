# Git setup

# Author details
git config --global user.name "Andrew Marino"
if ! git config --get user.email > /dev/null ; then
  read -p 'Enter git config user.email: ' email
  git config --global user.email "$email"
fi

# Editor
git config --global core.editor "nvim"
gitignore_file=$HOME/.gitignore-global
if [ ! -f "$gitignore_file" ]; then
  echo .DS_Store >> $gitignore_file
fi
git config --global core.excludesfile ~/.gitignore-global

# Aliases
git config --global alias.s "status"
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:\
'%C(bold blue)%h%C(reset) - \
%C(bold green)(%aD)%C(reset) \
%s \
%C(dim)- %an%C(reset)\
%C(bold yellow)%d%C(reset)' --all"
