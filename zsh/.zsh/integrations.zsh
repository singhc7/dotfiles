# ==========================================
# External Tool Integrations
# ==========================================

# --- fzf ---
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# --- Deno ---
if [ -f "$HOME/.deno/env" ]; then
    . "$HOME/.deno/env"
fi

# --- Nix ---
# Guarded Nix environment initialization
if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# --- zoxide ---
# Initialize zoxide (defines z and zi)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    # Also alias cd to z to allow both commands to work
    alias cd="z"
    # Optimization: Limit the frequency of database cleanup
    export _ZO_MAXAGE=10000
fi
