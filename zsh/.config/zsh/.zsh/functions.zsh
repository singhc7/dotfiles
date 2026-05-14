# ==========================================
# Functions
# ==========================================

# --- Detect host package manager ---
# Returns one of: nixos | pacman | "" (unknown). Cached per shell.
_pkg_host() {
    if [[ -n "$_PKG_HOST_CACHE" ]]; then
        print -r -- "$_PKG_HOST_CACHE"
        return
    fi
    if [[ -f /etc/NIXOS ]] || command -v nixos-rebuild >/dev/null 2>&1; then
        _PKG_HOST_CACHE=nixos
    elif command -v pacman >/dev/null 2>&1; then
        _PKG_HOST_CACHE=pacman
    else
        _PKG_HOST_CACHE=
    fi
    print -r -- "$_PKG_HOST_CACHE"
}

# --- Pacman preflight (Arch only) ---
# Bails out before any sudo prompt if the pacman db is locked.
_pacman_preflight() {
    local lock=/var/lib/pacman/db.lck
    if [[ -e "$lock" ]] && ! pgrep -x pacman >/dev/null; then
        echo "Stale pacman lock at $lock (no pacman process running)." >&2
        echo "Inspect it, then remove with:  sudo rm $lock" >&2
        return 1
    fi
}

# --- upsystem: full system upgrade ---
# NixOS: rebuild the system from the flake/config and pull newer inputs.
# Arch:  pacman -Syu (or paru if an AUR helper is present).
upsystem() {
    case "$(_pkg_host)" in
    nixos)
        sudo nixos-rebuild switch --upgrade
        ;;
    pacman)
        _pacman_preflight || return
        if command -v paru >/dev/null 2>&1; then
            paru -Syu
        else
            sudo pacman -Syu
        fi
        ;;
    *)
        echo "upsystem: no supported package manager (NixOS or pacman) found." >&2
        return 1
        ;;
    esac
}

# --- clsystem: drop stale state from the package manager ---
# NixOS: garbage-collect old generations and hardlink-dedupe the store.
# Arch:  remove orphan packages and drop the uninstalled package cache.
clsystem() {
    case "$(_pkg_host)" in
    nixos)
        sudo nix-collect-garbage -d || return 1
        sudo nix store optimise
        ;;
    pacman)
        _pacman_preflight || return
        local orphans
        orphans=$(pacman -Qdtq) || true
        if [[ -n "$orphans" ]]; then
            echo "$orphans" | sudo pacman -Rns - || return 1
        else
            echo "No orphan packages."
        fi
        sudo pacman -Sc
        ;;
    *)
        echo "clsystem: no supported package manager (NixOS or pacman) found." >&2
        return 1
        ;;
    esac
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
        # shellcheck disable=SC2086,SC1083
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
