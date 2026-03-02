# Uncomment to measure zsh loading time along with bottom zprof
# zmodload zsh/zprof
# ===============================================================
# ENVIRONMENT & PATHS
# ===============================================================
export OBSIDIAN_VAULT="$HOME/Google Drive/My Drive/obsidian-work"
export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# ===============================================================
# PERFORMANCE OPTIMIZATIONS
# ===============================================================
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ===============================================================
# PLUGIN MANAGER (Antidote)
# ===============================================================
# Completions (must come AFTER all plugins)
autoload -Uz compinit
compinit -C

source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# Smart static loading – only regenerates when needed
if [[ ! -r ~/.zsh_plugins.zsh ]] || [[ ~/.zsh_plugins.txt -nt ~/.zsh_plugins.zsh ]]; then
  echo "🔄 Regenerating Antidote plugins..."
  antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh
fi

source ~/.zsh_plugins.zsh

# Disable the old 'menu selection' to let fzf-tab take over
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# ===============================================================
# fzf-tab – styled fuzzy completions
# ===============================================================
# Tokyo Night / Starship matching colors for FZF
export FZF_DEFAULT_OPTS="--ansi \
--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 \
--color=fg+:#c0caf5,bg+:#2f3549,hl+:#7dcfff \
--color=info:#7aa2f7,prompt:#bb9af7,pointer:#7dcfff \
--color=marker:#9ae37d,spinner:#9ae37d,header:#9ae37d \
--prompt='❯ ' --pointer='▶' --marker='✓'"
zstyle ':fzf-tab:complete:*' fzf-preview 'bat --color=always --style=numbers $realpath 2>/dev/null || ls -l $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath 2>/dev/null || ls -l $realpath'
zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps --pid=$word -o cmd --no-headers'

# Preview for your custom directory shortcuts
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -d $realpath ]] && eza --tree --level=1 --color=always $realpath || bat --color=always --style=numbers $realpath'

# Preview for 'git add' (shows the diff of the file)
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta || git diff $word'

# Preview for 'git checkout' or 'git switch' (shows the last commit on that branch)
zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
	'git log -n 1 --color=always $word'

# Preview for 'git show' (shows the commit content)
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'git show --color=always $word'

# Preview for 'git checkout' (files)
zstyle ':fzf-tab:complete:git-checkout:argument-1' fzf-preview \
	'git diff $word | delta || git diff $word'
# ===============================================================
# MODERN TOOLS (fzf, zoxide, bat, ripgrep)
# ===============================================================
# fzf (Ctrl+R history, Ctrl+T files, etc.)
source <(fzf --zsh) 2>/dev/null || true

# zoxide (smart `cd` replacement)
eval "$(zoxide init zsh)" 2>/dev/null || true

# ===============================================================
# PROMPT (Starship)
# ===============================================================
# This line stops the starship_zle-keymap-select-wrapped recursion
zle -N zle-keymap-select 2>/dev/null || true

eval "$(starship init zsh)"

# ===============================================================
# ALIASES & FUNCTIONS
# ===============================================================
alias ls="lsd"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias cat="bat --paging=never"      # beautiful syntax highlighting
alias grep="rg --color=auto"        # fast ripgrep

# git aliases
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

# yazi function
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Source external files
source "$HOME/.config/zsh/functions/custom-dirs.zsh"
source "$HOME/.config/zsh/functions/utils.zsh"
source "$HOME/.config/zsh/functions/og.zsh"

# Load environment variables
for env_file in "$HOME/.config/zshenv/env-private.zsh" "$HOME/.config/zshenv/env-public.zsh"; do
  [ -f "$env_file" ] && source "$env_file"
done

# EZA Theme
export EZA_CONFIG_DIR="$HOME/.config/.dotfiles/eza"

# Obsidian review alias
alias or='cd ${OBSIDIAN_VAULT:-$HOME/Google Drive/My Drive/obsidian-work} && nvim ./inbox/*.md'

# ===============================================================
# Autosuggestions styling & bindings
# ===============================================================
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
bindkey '^[[C' autosuggest-accept     # Right Arrow = accept suggestion
bindkey '^f'   autosuggest-accept     # Ctrl+F = accept suggestion (better than vi-forward-word)
# END CONFIGURATION

# Uncomment to measure zsh loading time along with top zprof
# zprof
