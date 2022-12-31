# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# history stuff
HISTCONTROL=ignoreboth
HISTSIZE=5000
shopt -s histappend

# custom prompt
function parse_git_dirty {
  [[ -z $(git status --porcelain 2>/dev/null) ]] || echo "*"
}
function parse_git_branch {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
# set xterm title: https://askubuntu.com/a/405769
P_TITLE='\[\e]0;\u@\h: \w\a\]'
P_RESET='\[$(tput sgr0)\]'
P_CYAN='\[\033[36m\]'
P_WHITE='\[\033[37m\]'
PS1="${P_TITLE}${P_RESET}\n${P_CYAN}\w ${P_WHITE}\$(parse_git_branch)${P_RESET}\n${P_CYAN}>${P_RESET} "

mkdir -p "$HOME/.local/bin"
PATH="$HOME/.local/bin:$PATH"

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
elif [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
fi

if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/.pyenv/bin" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# aliases

if command -v exa > /dev/null; then
  alias ls='exa'
  alias ll='exa -alF'
else
  alias ll='ls -alF'
fi

alias lg='lazygit'
alias gs='git status'
alias gd='git diff'

git config --global alias.logp 'log --pretty --oneline --graph'

