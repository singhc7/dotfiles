# ==========================================
# Environment Variables & Exports
# ==========================================

# --- Editor ---
export EDITOR='nvim'
export VISUAL='nvim'

# --- Path Modifications ---
# User local bin
export PATH="$HOME/.local/bin:$PATH"
# NPM global packages
export PATH="$HOME/.npm-global/bin:$PATH"

# --- NNN Configuration ---
# Plugins:
# o: fzopen (fuzzy search)
# n: nuke (smart opener)
# r: rclone (loads rclone to mount cloud drives)
# z: zoxide (uses autojump feature from zoxide)
# m: nmount to mount physical drives
# t: t will be safe trash
export NNN_PLUG='o:fzopen;n:nuke;r:rclone;m:nmount;z:autojump;t:trash'

# General Settings
export NNN_OPTS="adeH"          # detail mode, use EDITOR, show hidden
export NNN_ICONS=1
export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

# --- Rclone Power Settings ---
# Boosts performance for syncs, copies, and mounts without touching rclone.conf
export RCLONE_TRANSFERS=8              # More parallel file transfers
export RCLONE_CHECKERS=16             # Faster file checking during syncs
export RCLONE_BUFFER_SIZE=64M         # Larger memory buffer for smoother streaming
export RCLONE_DRIVE_USE_TRASH=true    # GDrive specific: safety first
export RCLONE_FAST_LIST=true          # Drastically reduces API calls for syncs
export RCLONE_VFS_CACHE_MODE=writes   # Enables basic file caching for mounts
