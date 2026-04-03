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

# --- Package Management (pacman & Nix{through lix}) ---
# Update system and user packages with proper guard rails
# pacman
#  -S : Sync operations (interact with remote repository databases)
#  -y : Refresh (download fresh copies of the master package databases from servers)
#  -u : Sysupgrade (compare local packages to the fresh databases and upgrade them)
alias upsystem='{ command -v pacman >/dev/null 2>&1 && sudo pacman -Syu || true } && \
                  { command -v nix >/dev/null 2>&1 && nix profile upgrade --all || true } && \
                  { command -v nix-channel >/dev/null 2>&1 && nix-channel --update || true }'

# Clean up system caches and unused packages
# pacman -Qdtq
#  -Q : Query the local package database
#  -d : Filter for packages installed as dependencies
#  -t : Filter for unrequired packages (true orphans)
#  -q : Quiet output (raw package names only, stripped of versions/descriptions)

#   | : Pipe the raw list of names to the next command

# pacman -Rns -
#  -R : Remove packages
#  -n : Nosave (completely delete config files instead of making .pacsave backups)
#  -s : Recursive (remove the target package's unused dependencies as well)
#   - : Read the target package names from standard input (the pipe)

# pacman -Sc
#  -S : Sync operations (cache management is categorized under sync commands)
#  -c : Clean (a single 'c' removes cached packages that are no longer installed)
alias clsystem='{ command -v pacman >/dev/null 2>&1 && pacman -Qdtq | sudo pacman -Rns - && sudo pacman -Sc || true } && \
                    { command -v nix-collect-garbage >/dev/null 2>&1 && nix-collect-garbage -d || true }'

# Nix shorthand for common operations
if command -v nix >/dev/null 2>&1; then
    alias ns="nix-shell"
    alias np="nix profile"
    alias ni="nix profile install" # Shorthand to install from nixpkgs
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
