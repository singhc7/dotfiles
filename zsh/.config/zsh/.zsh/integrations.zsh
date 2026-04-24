# ==========================================
# External Tool Integrations
# ==========================================

# --- fzf ---
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# --- zoxide ---
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    export _ZO_MAXAGE=10000
fi

# --- direnv ---
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
