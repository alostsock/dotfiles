source "$HOME/.cargo/env.fish"
fnm env --use-on-cd --shell fish | source

if status is-interactive
    set fish_greeting
    alias ll='ls -la'
    alias tn='tmux new-session -d -s'
    alias ta='tmux a'
    alias lg='lazygit'

    git config --global alias.co checkout
    alias gs='git status'
    alias gd='git diff'
end

