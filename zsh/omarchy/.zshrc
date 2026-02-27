
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Obsidian Vault
# export OBSIDIAN_VAULT="$HOME/Google Drive/My Drive/obsidian-work"
# Kitty
# export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"

# My Custom ALIAS
# alias ls="lsd"
# alias lla="ll -a"
# fzf with preview
alias prev='fzf --preview "bat --style=numbers --color=always {}" --preview-window=up:30%:wrap'
# git ALIAS
alias gc="git commit -m"
alias gp="git push"
alias ga="git add"
alias gaa="git add ."
alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias gl="git log --oneline --decorate --graph --all"
alias glog="git log --oneline --decorate --graph"
alias gpl="git pull"
alias gto="git switch"
alias gtob="git switch -c"
alias gfetch="git fetch"
alias gsth="git stash"


# TODO: uncomment when custom dirs logic has been implemented
# custom directories listing
# source $HOME/.config/zsh/functions/custom-dirs.zsh

# TODO: retrieve handy functions
# handy functions
# source $HOME/.config/zsh/functions/utils.zsh

# TODO: uncoment after installing obsidian
# Obsidian Organize and Review
# source $HOME/.config/zsh/functions/og.zsh

# TODO: uncomment after NVM has been installed
# nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# TODO: config cargo
# cargo
# export PATH="$HOME/.cargo/bin:$PATH"

# TODO: configure YAZI
# yazi configuration
# function y() {
# 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
# 	yazi "$@" --cwd-file="$tmp"
# 	IFS= read -r -d '' cwd < "$tmp"
# 	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
# 	rm -f -- "$tmp"
# }

# TODO: load ENV variables
# Load environment variables
# for env_file in \
#     "$HOME/.config/zshenv/env-private.zsh" \
#     "$HOME/.config/zshenv/env-public.zsh"; do
#   if [ -f "$env_file" ]; then
#     source "$env_file"
#   fi
# done

# TODO: uncomment to enable PNPM
# pnpm
# export PNPM_HOME="~/Library/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
# pnpm end

# Added by Antigravity
# export PATH="/Users/viktor/.antigravity/antigravity/bin:$PATH"
