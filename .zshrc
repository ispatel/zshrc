
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/ishanpatel/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/ishanpatel/opt/anaconda3/etc/profile.d/conda.sh" ]; then
#         . "/Users/ishanpatel/opt/anaconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/ishanpatel/opt/anaconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

source ~/venv-metal/bin/activate

# Global array

typeset -A _ramen
_ramen[ZSH_HOME]="$HOME/.zsh"

# Set up zsh color environment
#
# Default environment assumes that you have 256 colors

_ramen[WHITE]="%{%F{15}%}"
_ramen[GRAY]="%{%F{8}%}"
_ramen[LIGHT_GRAY]="%{%F{7}%}"
_ramen[RED]="%{%F{9}%}"
_ramen[BLUE]="%{%F{12}%}"
_ramen[CYAN]="%{%F{14}%}"
_ramen[YELLOW]="%{%F{11}%}"
_ramen[GREEN_YELLOW]="%{%F{154}%}"
_ramen[GREEN]="%{%F{2}%}"
_ramen[MAGENTA]="%{%F{13}%}"
_ramen[ORANGE]="%{%F{214}%}"

# Text changes
_ramen[BOLD_START]="%B"
_ramen[BOLD_END]="%b"


function zsh_command_time {
  if [ -n "$ZSH_COMMAND_TIME" ]; then
    local hours=$(($ZSH_COMMAND_TIME/3600))
    local min=$(($ZSH_COMMAND_TIME/60))
    local sec=$(($ZSH_COMMAND_TIME%60))
    if [ "$ZSH_COMMAND_TIME" -le 1 ]; then
      _ramen[COMMAND_TIME]=""
    elif [ "$ZSH_COMMAND_TIME" -le 60 ]; then
      _ramen[COMMAND_TIME]="${ZSH_COMMAND_TIME}s "
    elif [ "$ZSH_COMMAND_TIME" -gt 60 ] && [ "$ZSH_COMMAND_TIME" -le 180 ]; then
      _ramen[COMMAND_TIME]="${min}min ${sec}s "
    else
      if [ "$hours" -gt 0 ]; then
        min=$(($min%60))
        _ramen[COMMAND_TIME]="%B$_ramen[RED]${hours}h%b$_ramen[GRAY] ${min}min ${sec}s "
      else
        _ramen[COMMAND_TIME]="${min}min ${sec}s "
      fi
    fi
  fi
}

# Aliases

alias v='vim'
alias vi='vim'
alias l='ls'
alias cp='cp -v'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'
alias docker='nocorrect docker'
alias gis='git status'

alias ls='ls --color=always'
#alias ll='ls -la --color=always'

# Binds

bindkey -e
bindkey '^w' forward-word
bindkey '^b' backward-word
bindkey '^d' kill-whole-line
bindkey '^k' backward-kill-word
bindkey '^j' kill-word

# Completion

autoload -Uz compinit
autoload -U +X bashcompinit && bashcompinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SList: %p%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SList: %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Options

setopt append_history
setopt extended_history
setopt sharehistory
setopt hist_reduce_blanks
setopt always_to_end
setopt complete_in_word
setopt auto_menu
setopt correct
setopt correctall
setopt list_packed

# Prompt
function preexec {
  timer=${timer:-$SECONDS}
  export ZSH_COMMAND_TIME=""
}

function precmd {
  _ramen[EXIT_CODE]=$?

  if [ $timer ]; then
    _ramen[COMMAND_TIME]=$(($SECONDS - $timer))
    export ZSH_COMMAND_TIME="$_ramen[COMMAND_TIME]"
    zsh_command_time
    unset timer
  fi

  local USER="$_ramen[RED]%n$_ramen[WHITE]@$_ramen[BLUE]%m"
  local DIR="$_ramen[GREEN_YELLOW]%~"

  # Paint the USER red if the user is root
  [ $UID -eq 0 ] && local USER="$_ramen[WHITE]%n@%m"

  # Paint USER red if command fails
  [ ! $_ramen[EXIT_CODE] -eq 0 ] && local USER="$_ramen[RED]%n@%m"

  export PROMPT="$_ramen[BOLD_START]$USER$_ramen[WHITE]:$DIR$_ramen[WHITE]$_ramen[BOLD_END]%# "
  export RPROMPT="$_ramen[GRAY]$_ramen[COMMAND_TIME]$_ramen[WHITE]"

  # Set window title in xterm
  case $TERM in
    xterm*|rxvt*) print -Pn "\e]0;%n@%m:%~\a" ;;
    *) ;;
  esac
}

export SPROMPT="%B%F{red}'%R'%b%f -> %B%F{red}'%r'%b%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]? "

# updates PATH for the Google Cloud SDK.
if [ -f '/Users/ishanpatel/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ishanpatel/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# enables shell command completion for gcloud.
if [ -f '/Users/ishanpatel/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ishanpatel/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

complete -o nospace -C /usr/local/bin/terraform terraform

export USE_GKE_GCLOUD_AUTH_PLUGIN=True 

# Handle Mac platform
CPU=$(uname -p)
if [[ "$CPU" == "arm" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export EDITOR=/opt/homebrew/bin/nano
    alias nano=/opt/homebrew/bin/nano
    alias oldbrew=/usr/local/bin/brew
else
    export PATH="/usr/local/bin:$PATH"
    export EDITOR=/usr/local/bin/nano
    alias nano=/usr/local/bin/nano
fi

