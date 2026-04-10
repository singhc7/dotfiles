# ==========================================
# Functions
# ==========================================

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
mkcd() {
    mkdir -p $1 && cd $1;
}
