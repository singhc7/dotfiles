# ==========================================
# Aliases
# ==========================================

# --- nvim ---
if command -v nvim >/dev/null 2>&1; then
    alias vim=nvim
fi

# --- Eza (Modern replacement for ls) ---
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --git --group-directories-first'
    alias la='eza -lha --icons --git --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first'
    alias l.='eza -d .* --icons --group-directories-first'
fi

# --- Package Management (DNF & Nix) ---
# Update system and user packages with proper guard rails
alias upsystem='{ command -v dnf >/dev/null 2>&1 && sudo dnf upgrade -y || true } && \
                  { command -v nix >/dev/null 2>&1 && nix profile upgrade --all || true } && \
                  { command -v nix-channel >/dev/null 2>&1 && nix-channel --update || true }'

# Clean up system caches and unused packages
alias clsystem='{ command -v dnf >/dev/null 2>&1 && sudo dnf autoremove -y && sudo dnf clean all || true } && \
                    { command -v nix-collect-garbage >/dev/null 2>&1 && nix-collect-garbage -d || true }'

# Nix shorthand for common operations
if command -v nix >/dev/null 2>&1; then
    alias ns="nix-shell"
    alias np="nix profile"
    alias na="nix profile add" # Shorthand to install from nixpkgs
    alias nu="nix profile upgrade"
    alias nr="nix profile remove"
    alias nls="nix profile list"
fi

# --- Rclone Power Tools ---
if command -v rclone >/dev/null 2>&1; then
    # Optimized mount (high-performance VFS caching)
    alias rcmount='rclone mount --vfs-cache-mode full \
                           --vfs-cache-max-age 24h \
                           --vfs-cache-max-size 10G \
                           --vfs-read-chunk-size 128M \
                           --vfs-read-chunk-size-limit 1G \
                           --daemon'

    # Fast and safe mirror sync
    alias rcsync='rclone sync -P --track-renames --fix-case'

    # Interactive remote file explorer
    alias rcls='rclone lsjson --human-readable --stat'
fi
