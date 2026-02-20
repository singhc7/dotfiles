# 1. Powerlevel10k Instant Prompt (Must be at the very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. Load Antidote (Your Plugin Manager)
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# 3. Load your plugins (Includes Powerlevel10k, Autosuggestions, etc.)
antidote load

# 4. Load Powerlevel10k Visual Settings
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
. "/home/chahat/.deno/env"

export PATH="$HOME/.local/bin:$PATH"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
# --- NNN CONFIGURATION ---

# 1. Plugins

# p: preview-tui (split pane)
# o: fzopen (fuzzy search)
# n: nuke (smart opener)
# r: rclone (loads rclone to mount cloud drives)
# z: zoxide (uses autojump feature from zoxide)
# m: nmount to mount physical drives
# t: t will be safe trash
export NNN_PLUG='p:preview-tui;o:fzopen;n:nuke;r:rclone;m:nmount;z:autojump;t:trash'

# 2. Preview Settings
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_IMGVIEWER='chafa'  # Use chafa for images

# This tells nnn to use tmux for splits
export NNN_SPLIT_PREVIEW_TMUX=1

# this is to render icons
export NNN_ICONS=1

# 3. CD on Quit Function (ZSH Version)
n () {
    # Block nesting of nnn in subshells
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The behaviour is controlled by NNN_TMPFILE
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Run nnn
    nnn "$@"

    # On exit, read the tempfile and cd if it exists
    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# --- Zoxide configuration ---
eval "$(zoxide init zsh)"

# --- Aliases ---

# 1. To update all the packages
alias update-all='sudo dnf upgrade && flatpak update && snap refresh && pipx upgrade-all'

# 2. To clean and remove old dependencies
alias clean-system='sudo dnf autoremove && flatpak uninstall --unused && pipx interpreter prune'


