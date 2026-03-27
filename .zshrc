# === Environment ===
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
export PATH="$PATH:$HOME/tinygo/bin"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export EDITOR='hx'
export OC_EDITOR="hx"
export SSH_AUTH_SOCK="/run/user/$(id -u)/keyring/ssh"
export MANPATH="/usr/local/man:$MANPATH"
# fzf: use fd for file/dir finding, bat for previews, theme-matched colors
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS=" \
  --height=40% --layout=reverse --border=rounded --cycle --scroll-off=4 \
  --color=bg+:#393939,fg+:#ffffff,hl:#3a97d4,hl+:#3a97d4 \
  --color=info:#1ea672,prompt:#1ea672,pointer:#ed5f74,marker:#c96ed0 \
  --color=spinner:#d97917,header:#3a97d4,border:#393939 \
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :200 {}' --preview-window=right:50%:wrap"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'ls --color=always {}'"

# Claude Code
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=$GCP_PRODUCT_ID

# === Zinit ===
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# OMZ core libs
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZL::prompt_info_functions.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZT::robbyrussell

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# OMZ plugin snippets for completions and aliases
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::golang

# Docker completions (plugin has a subdirectory, needs ice)
zinit ice as"completion"
zinit snippet OMZP::docker/completions/_docker

# Wakatime (separate repo, not a standard OMZ plugin)
zinit light sobolevn/wakatime-zsh-plugin

# === Completions ===
autoload -Uz compinit && compinit
zinit cdreplay -q

CASE_SENSITIVE="true"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:(hx|cat|bat|less|head|tail):*' fzf-preview \
  'bat --style=numbers --color=always --line-range :100 $realpath 2>/dev/null || ls --color $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# === Tool Initialization ===
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Atuin env (adds ~/.atuin/bin to PATH)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
unalias zi 2>/dev/null; alias zi='__zoxide_zi'
eval "$(atuin init zsh)"

# Atuin as autosuggestion strategy (must be after atuin init)
export ZSH_AUTOSUGGEST_STRATEGY=(atuin history completion)

# Accept autosuggestion word-by-word with Ctrl+Right
bindkey '^[[1;5C' forward-word

# === Functions ===

znew() { zellij action new-tab --layout "$1" --name "$2" --cwd "$3"; }

zwork() {
  local layout_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zellij/layouts"

  local project
  project=$(fd --type d --max-depth 2 . 2>/dev/null \
    | fzf --prompt="Folder > " --preview='ls --color=always {}')
  [ -z "$project" ] && return 0

  local layout
  layout=$(fd --type f --extension kdl . "$layout_dir" 2>/dev/null \
    | sed 's|.*/||; s/\.kdl$//' \
    | fzf --prompt="Layout > ")
  [ -z "$layout" ] && return 0

  local tab_name
  echo -n "Tab name [${project%/}]: "; read tab_name
  zellij action new-tab --layout "$layout" --name "${tab_name:-${project%/}}" --cwd "$PWD/$project"
}

# === Aliases ===
alias work-git='git config user.email "avinal@redhat.com"'
