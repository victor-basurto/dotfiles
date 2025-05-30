# !$HOME/.config/zsh/functions/on.zsh

file_name=$(echo $1 | tr ' ' '-')
formatted_file_name=$(date "+%Y-%m-%d")_${file_name}.md
cd "${OBSIDIAN_VAULT:-G:/My Drive/obsidian-work}" || exit
touch "inbox/${formatted_file_name}"
nvim "inbox/${formatted_file_name}"

