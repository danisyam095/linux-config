# ============================================================
# ZSH
# Arch Linux / Niri / Kitty
# Zinit + Starship + FZF + Zoxide + Eza
# JetBrainsMono Nerd Font / Tokyo Night
# ============================================================


# ============================================================
# ENVIRONMENT
# ============================================================

export EDITOR="nvim"
export VISUAL="nvim"

export PAGER="less"
export LESS="-R"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export PATH="$HOME/.local/bin:$PATH"

mkdir -p "$XDG_CACHE_HOME/zsh"


# ============================================================
# HISTORY
# ============================================================

HISTFILE="$HOME/.zsh_history"

HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt SHARE_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS


# ============================================================
# DIRECTORY
# ============================================================

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT


# ============================================================
# COMPLETION
# ============================================================

setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt MENU_COMPLETE

setopt GLOB_DOTS
setopt EXTENDED_GLOB

setopt NO_BEEP


# ============================================================
# ZINIT
# ============================================================

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
    print -u2 "ERROR: Zinit tidak ditemukan:"
    print -u2 "$ZINIT_HOME/zinit.zsh"
    return 1
fi

source "$ZINIT_HOME/zinit.zsh"


# ============================================================
# ZSH COMPLETIONS
# HARUS SEBELUM COMPINIT
# ============================================================

zinit light zsh-users/zsh-completions


# ============================================================
# COMPINIT
# ============================================================

autoload -Uz compinit

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"


# ============================================================
# COMPLETION STYLE
# ============================================================

zstyle ':completion:*' menu select

zstyle ':completion:*' group-name ''

zstyle ':completion:*' verbose yes

zstyle ':completion:*' use-cache on

zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*'

zstyle ':completion:*' special-dirs true

zstyle ':completion:*' file-sort modification

zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':completion:*:messages' format '[%d]'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# ============================================================
# FZF-TAB
# HARUS SETELAH COMPINIT
# ============================================================

zinit light Aloxaf/fzf-tab


# FZF-tab appearance
zstyle ':fzf-tab:*' fzf-flags \
    '--height=45%' \
    '--layout=reverse' \
    '--border=rounded'

zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:*' continuous-trigger '/'

zstyle ':fzf-tab:complete:cd:*' \
    fzf-preview 'eza -1 --color=always $realpath 2>/dev/null'


# ============================================================
# AUTOSUGGESTIONS
# ============================================================

export ZSH_AUTOSUGGEST_USE_ASYNC=true

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50

export ZSH_AUTOSUGGEST_HISTORY_IGNORE='sudo *|pass *|passwd *'

zinit light zsh-users/zsh-autosuggestions


# ============================================================
# HISTORY SUBSTRING SEARCH
# ============================================================

export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

zinit light zsh-users/zsh-history-substring-search


# ============================================================
# FAST SYNTAX HIGHLIGHTING
# HARUS DIMUAT TERAKHIR DARI PLUGIN
# ============================================================

zinit light zdharma-continuum/fast-syntax-highlighting


# ============================================================
# KEYMAP
# ============================================================

bindkey -e


# ============================================================
# HISTORY SEARCH
# ============================================================

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down


# ============================================================
# MOVEMENT
# ============================================================

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey '^[[3;5~' kill-word


# ============================================================
# AUTOSUGGESTION
# ============================================================

bindkey '^[[C' forward-char

bindkey '^ ' autosuggest-accept


# ============================================================
# FZF
# ============================================================

if (( $+commands[fzf] )); then
    source <(fzf --zsh)

    export FZF_DEFAULT_OPTS="
        --height=45%
        --layout=reverse
        --border=rounded
        --info=inline
    "
fi


# ============================================================
# ZOXIDE
# ============================================================

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi


# ============================================================
# EZA
# ============================================================

if (( $+commands[eza] )); then

    alias ls='eza --icons=auto'

    alias l='eza --icons=auto'

    alias ll='eza -lah --icons=auto'

    alias la='eza -a --icons=auto'

    alias lt='eza --tree --level=2 --icons=auto'

    alias lta='eza --tree --level=2 -a --icons=auto'

    alias lg='eza -lah --git --icons=auto'

else

    alias l='ls -CF'

    alias ll='ls -lah'

    alias la='ls -A'

fi


# ============================================================
# NAVIGATION
# ============================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ~='cd ~'
alias c='clear'
alias sp='sudo pacman'

# ============================================================
# ZSH
# ============================================================

alias zshrc='nvim ~/.zshrc'

alias reload='exec zsh'
alias reload-zsh='exec zsh'
alias reload-niri='niri msg action load-config-file'

reload-waybar() {
    local -a pids
    pids=(${(f)"$(pgrep -x waybar)"})

    if (( ${#pids} == 0 )); then
        print -u2 "Waybar tidak sedang berjalan."
        return 1
    fi

    kill -SIGUSR2 "${pids[@]}"
}

reload-kitty() {
    local -a pids
    pids=(${(f)"$(pgrep -x kitty)"})

    if (( ${#pids} == 0 )); then
        print -u2 "Kitty tidak sedang berjalan."
        return 1
    fi

    kill -SIGUSR1 "${pids[@]}"
}

reload-ui() {
    niri msg action load-config-file && reload-waybar
}


# ============================================================
# GIT
# ============================================================

alias gs='git status'

alias ga='git add'

alias gaa='git add --all'

alias gc='git commit'

alias gca='git commit --amend'

alias gp='git push'

alias gpl='git pull'

alias gd='git diff'

alias gds='git diff --stat'

alias gl='git log --oneline --decorate --graph'

alias gb='git branch'

alias gco='git checkout'


# ============================================================
# PACMAN
# ============================================================

alias update='sudo pacman -Syu'

alias install='sudo pacman -S'

alias remove='sudo pacman -Rns'

alias search='pacman -Ss'

alias clean='sudo pacman -Sc'


# ============================================================
# SAFE COMMANDS
# ============================================================

alias cp='cp -i'

alias mv='mv -i'

alias rm='rm -i'


# ============================================================
# ZINIT
# ============================================================

alias zup='zinit update --all'

alias zlist='zinit list'

alias zstatus='zinit report'

alias zself='zinit self-update'


# ============================================================
# USEFUL FUNCTIONS
# ============================================================


# Create directory and enter
mkcd() {
    if [[ -z "$1" ]]; then
        print -u2 "Usage: mkcd <directory>"
        return 1
    fi

    mkdir -p -- "$1" && cd -- "$1"
}


# Search command history
hgrep() {
    if [[ -z "$1" ]]; then
        print -u2 "Usage: hgrep <text>"
        return 1
    fi

    fc -l 1 | grep -i -- "$1"
}


# Create temporary directory
tmpdir() {
    local dir

    dir="$(mktemp -d)" || return 1

    cd -- "$dir" || return 1

    print "Temporary directory: $dir"
}


# Extract common archive formats
extract() {
    if [[ -z "$1" ]]; then
        print -u2 "Usage: extract <file>"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        print -u2 "File tidak ditemukan: $1"
        return 1
    fi

    case "$1" in
        *.tar.bz2|*.tbz2)
            tar xjf "$1"
            ;;
        *.tar.gz|*.tgz)
            tar xzf "$1"
            ;;
        *.tar.xz|*.txz)
            tar xJf "$1"
            ;;
        *.tar.zst)
            tar --zstd -xf "$1"
            ;;
        *.tar)
            tar xf "$1"
            ;;
        *.zip)
            unzip "$1"
            ;;
        *.7z)
            7z x "$1"
            ;;
        *.rar)
            unrar x "$1"
            ;;
        *.gz)
            gunzip "$1"
            ;;
        *.bz2)
            bunzip2 "$1"
            ;;
        *.xz)
            unxz "$1"
            ;;
        *)
            print -u2 "Format tidak didukung: $1"
            return 1
            ;;
    esac
}


# ============================================================
# STARSHIP
# ============================================================

if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi


# ============================================================
# END
# ============================================================

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/home/dani/.bun/_bun" ] && source "/home/dani/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME='/home/dani/.local/share/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
