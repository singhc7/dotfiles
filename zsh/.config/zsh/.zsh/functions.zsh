# ==========================================
# Functions
# ==========================================

# --- Pacman preflight (shared by upsystem / clsystem) ---
# Bails out before any sudo prompt if pacman is missing or the db is locked.
_pacman_preflight() {
    command -v pacman >/dev/null 2>&1 || {
        echo "pacman not found — this command is Arch-only." >&2
        return 1
    }

    local lock=/var/lib/pacman/db.lck
    if [[ -e "$lock" ]] && ! pgrep -x pacman >/dev/null; then
        echo "Stale pacman lock at $lock (no pacman process running)." >&2
        echo "Inspect it, then remove with:  sudo rm $lock" >&2
        return 1
    fi
}

# --- upsystem: full system upgrade ---
#   -S sync, -y refresh dbs, -u sysupgrade.
# If an AUR helper (paru/yay) is installed, prefer it so the AUR tree is
# upgraded in the same pass; otherwise fall back to plain pacman.
upsystem() {
    _pacman_preflight || return

    if command -v paru >/dev/null 2>&1; then
        paru -Syu
    elif command -v yay >/dev/null 2>&1; then
        yay -Syu
    else
        sudo pacman -Syu
    fi
}

# --- clsystem: prune orphans + clean package cache ---
#   pacman -Qdtq : list packages installed as deps and no longer required.
#   pacman -Rns  : recursive remove + scrub configs (--nosave) + sweep deps.
#   pacman -Sc   : drop cached packages that are no longer installed.
# Guards against the empty-orphans case (pacman -Rns errors on empty stdin).
clsystem() {
    _pacman_preflight || return

    local orphans
    orphans=$(pacman -Qdtq) || true
    if [[ -n "$orphans" ]]; then
        echo "$orphans" | sudo pacman -Rns - || return 1
    else
        echo "No orphan packages."
    fi
    sudo pacman -Sc
}

# --- NNN: CD on Quit ---
# Allows nnn to change the shell directory on exit
n() {
    # Block nesting of nnn in subshells
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # Run nnn
    nnn "$@"

    # On exit, read the tempfile and cd if it exists
    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" >/dev/null
    fi
}

# --- Make a new directory and cd into it ---
mz() {
    mkdir -p "$1" && cd "$1" || return
}

# --- myenv: list aliases, functions, and exports in the current shell ---
# Sister to the `path` alias, which already prints $PATH one entry per line.
# Usage:
#   myenv                       all sections
#   myenv aliases   [pattern]   list aliases
#   myenv functions [pattern]   list user functions (skips _-prefixed internals)
#   myenv exports   [pattern]   list exported environment variables
# Pattern is a case-insensitive substring filter applied to that section.
myenv() {
    local section="${1:-all}"
    local pattern="${2:-}"

    local -a filter
    if [[ -n "$pattern" ]]; then
        filter=(grep -i -- "$pattern")
    else
        filter=(cat)
    fi

    case "$section" in
    aliases | a)
        print -P "%F{cyan}── Aliases ──%f"
        alias | "${filter[@]}"
        ;;
    functions | f | funcs)
        print -P "%F{cyan}── Functions ──%f"
        print -l ${(ok)functions} | grep -v '^_' | "${filter[@]}"
        ;;
    exports | e | env)
        print -P "%F{cyan}── Exports ──%f"
        env | sort | "${filter[@]}"
        ;;
    all)
        myenv aliases "$pattern"
        print
        myenv functions "$pattern"
        print
        myenv exports "$pattern"
        ;;
    -h | --help | help)
        print "usage: myenv [aliases|functions|exports|all] [pattern]"
        ;;
    *)
        print -u2 "myenv: unknown section '$section'"
        print -u2 "usage: myenv [aliases|functions|exports|all] [pattern]"
        return 1
        ;;
    esac
}

# --- Universal archive extractor ---
extract() {
    if [[ ! -f "$1" ]]; then
        echo "extract: '$1' is not a file" >&2
        return 1
    fi
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.rar) unrar x "$1" ;;
    *.xz) unxz "$1" ;;
    *.zst) unzstd "$1" ;;
    *)
        echo "extract: unsupported format '$1'" >&2
        return 1
        ;;
    esac
}
