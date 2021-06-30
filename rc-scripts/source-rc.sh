# Custom RC scripts
for file in ~/.scripts-rc/*.sh; do
  [[ -r $file ]] && . $file
done
unset file
