if status is-interactive
    set fish_greeting

    fish_add_path ~/.local/bin
    fish_add_path ~/.fly/bin

    source "$HOME/.cargo/env.fish"
    fnm env --use-on-cd --shell fish | source
    uv generate-shell-completion fish | source

    alias ll='ls -la'
    alias tn='tmux new-session -d -s'
    alias ta='tmux a'
    alias lg='lazygit'

    git config --global alias.co checkout
    alias gs='git status'
    alias gd='git diff'

    if test -r "$HOME/.secrets.fish"
        source "$HOME/.secrets.fish"
    end
end

