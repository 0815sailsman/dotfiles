eval "$(starship init zsh)"

# Config symlinks
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# Highlight symlinks
export LS_COLORS="ln=35:di=34:ex=32"  # bold magenta symlinks

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gst="git status"
alias gaa="git add --all"
alias gp="git push"
alias gcmsg="git commit -m "
alias task="go-task"
alias podmain="podman"

# Enable zsh autocomplate support
autoload -Uz compinit
compinit

# Add go binaries
export PATH=$PATH:~/go/bin

export GRAALVM_HOME=$HOME/Downloads/graalvm-community-openjdk-21.0.2+13.1/

# Load Angular CLI autocompletion.
source <(ng completion script)

# Add scripts directory to path
export PATH=$PATH:~/scripts

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"

. "$HOME/.local/share/../bin/env"

eval "$(/home/saylor/.local/bin/mise activate zsh)" # added by https://mise.run/zsh
