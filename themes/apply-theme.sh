#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

usage() {
    echo "Usage: $0 <palette-name>"
    echo ""
    echo "Available palettes:"
    for f in "$SCRIPT_DIR/palettes/"*.sh; do
        basename "$f" .sh
    done
    exit 1
}

[[ $# -lt 1 ]] && usage

PALETTE="$SCRIPT_DIR/palettes/$1.sh"
[[ ! -f "$PALETTE" ]] && echo "Palette '$1' not found." && usage

source "$PALETTE"

strip() { echo "${1#\#}"; }

# RGB decimal from hex (for zellij)
rgb() {
    local hex="${1#\#}"
    printf "%d %d %d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

echo "Applying theme: $THEME_NAME"
echo "================================"

# --- Ghostty theme ---
GHOSTTY_THEME="$DOTFILES_DIR/.config/ghostty/themes/$THEME_NAME"
cat > "$GHOSTTY_THEME" << EOF
palette = 0=$BLACK
palette = 1=$RED
palette = 2=$GREEN
palette = 3=$YELLOW
palette = 4=$BLUE
palette = 5=$MAGENTA
palette = 6=$CYAN
palette = 7=$WHITE

palette = 8=$BRIGHT_BLACK
palette = 9=$BRIGHT_RED
palette = 10=$BRIGHT_GREEN
palette = 11=$BRIGHT_YELLOW
palette = 12=$BRIGHT_BLUE
palette = 13=$BRIGHT_MAGENTA
palette = 14=$BRIGHT_CYAN
palette = 15=$BRIGHT_WHITE

background = $BG
foreground = $FG
cursor-color = $CURSOR
cursor-text = $BG
selection-background = $SELECTION_BG
selection-foreground = $SELECTION_FG
EOF

# Update ghostty config to reference this theme
sed -i "s/^theme = .*/theme = \"$THEME_NAME\"/" "$DOTFILES_DIR/.config/ghostty/config"
echo "[ok] Ghostty theme: $GHOSTTY_THEME"

# --- Helix ---
sed -i "s/^theme = .*/theme = \"$HELIX_THEME\"/" "$DOTFILES_DIR/.config/helix/config.toml"
echo "[ok] Helix theme: $HELIX_THEME"

# --- Alacritty ---
ALACRITTY="$DOTFILES_DIR/.config/alacritty/alacritty.toml"
if [[ -f "$ALACRITTY" ]]; then
    cat > "$ALACRITTY" << EOF
[window]
padding = { x = 7, y = 5 }
dynamic_padding = true
dynamic_title = false

[font]
normal = { family = "Iosevka Term", style = "Regular" }
bold = { family = "Iosevka Term", style = "Bold" }
italic = { family = "Iosevka Term", style = "Italic" }
bold_italic = { family = "Iosevka Term", style = "Bold Italic" }
size = 14

[colors.primary]
background = "$BG"
foreground = "$FG"

[colors.cursor]
text = "$BG"
cursor = "$CURSOR"

[colors.selection]
text = "$SELECTION_FG"
background = "$SELECTION_BG"

[colors.normal]
black = "$BLACK"
red = "$RED"
green = "$GREEN"
yellow = "$YELLOW"
blue = "$BLUE"
magenta = "$MAGENTA"
cyan = "$CYAN"
white = "$WHITE"

[colors.bright]
black = "$BRIGHT_BLACK"
red = "$BRIGHT_RED"
green = "$BRIGHT_GREEN"
yellow = "$BRIGHT_YELLOW"
blue = "$BRIGHT_BLUE"
magenta = "$BRIGHT_MAGENTA"
cyan = "$BRIGHT_CYAN"
white = "$BRIGHT_WHITE"

[cursor]
style = { shape = "Underline", blinking = "On" }

[selection]
save_to_clipboard = true
EOF
    echo "[ok] Alacritty colors updated"
fi

# --- Lazygit ---
LAZYGIT="$DOTFILES_DIR/.config/lazygit/config.yml"
if [[ -f "$LAZYGIT" ]]; then
    python3 -c "
import sys, re

config = open('$LAZYGIT').read()

new_theme = '''  theme:
    activeBorderColor:
      - \"$ACCENT\"
      - bold
    inactiveBorderColor:
      - \"$MUTED\"
    selectedLineBgColor:
      - \"$SURFACE\"
    optionsTextColor:
      - \"$CYAN\"
    unstagedChangesColor:
      - \"$RED\"
    defaultFgColor:
      - \"$FG\"'''

config = re.sub(
    r'  theme:.*?(?=\n\w|\ngit:|\ncustomCommands:|\nos:)',
    new_theme + '\n',
    config,
    flags=re.DOTALL
)
open('$LAZYGIT', 'w').write(config)
"
    echo "[ok] Lazygit theme updated"
fi

# --- Zellij ---
ZELLIJ="$DOTFILES_DIR/.config/zellij/config.kdl"
if [[ -f "$ZELLIJ" ]]; then
    python3 -c "
import re

config = open('$ZELLIJ').read()

new_theme = '''themes {
    $THEME_NAME {
        text_unselected {
            base $(rgb "$FG")
            background $(rgb "$SURFACE")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        text_selected {
            base $(rgb "$BRIGHT_WHITE")
            background $(rgb "$SELECTION_BG")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        ribbon_selected {
            base $(rgb "$BG")
            background $(rgb "$GREEN")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$YELLOW")
            emphasis_2 $(rgb "$MAGENTA")
            emphasis_3 $(rgb "$BLUE")
        }
        ribbon_unselected {
            base $(rgb "$BG")
            background $(rgb "$WHITE")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$FG")
            emphasis_2 $(rgb "$BLUE")
            emphasis_3 $(rgb "$MAGENTA")
        }
        table_title {
            base $(rgb "$GREEN")
            background 0
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        table_cell_selected {
            base $(rgb "$BRIGHT_WHITE")
            background $(rgb "$SELECTION_BG")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        table_cell_unselected {
            base $(rgb "$FG")
            background $(rgb "$SURFACE")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        list_selected {
            base $(rgb "$BRIGHT_WHITE")
            background $(rgb "$SELECTION_BG")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        list_unselected {
            base $(rgb "$FG")
            background $(rgb "$SURFACE")
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$GREEN")
            emphasis_3 $(rgb "$MAGENTA")
        }
        frame_selected {
            base $(rgb "$GREEN")
            background 0
            emphasis_0 $(rgb "$RED")
            emphasis_1 $(rgb "$CYAN")
            emphasis_2 $(rgb "$MAGENTA")
            emphasis_3 0
        }
        frame_highlight {
            base $(rgb "$YELLOW")
            background 0
            emphasis_0 $(rgb "$YELLOW")
            emphasis_1 $(rgb "$YELLOW")
            emphasis_2 $(rgb "$YELLOW")
            emphasis_3 $(rgb "$YELLOW")
        }
        exit_code_success {
            base $(rgb "$GREEN")
            background 0
            emphasis_0 $(rgb "$CYAN")
            emphasis_1 $(rgb "$SURFACE")
            emphasis_2 $(rgb "$MAGENTA")
            emphasis_3 $(rgb "$BLUE")
        }
        exit_code_error {
            base $(rgb "$RED")
            background 0
            emphasis_0 $(rgb "$YELLOW")
            emphasis_1 0
            emphasis_2 0
            emphasis_3 0
        }
        multiplayer_user_colors {
            player_1 $(rgb "$MAGENTA")
            player_2 $(rgb "$BLUE")
            player_3 0
            player_4 $(rgb "$YELLOW")
            player_5 $(rgb "$CYAN")
            player_6 0
            player_7 $(rgb "$RED")
            player_8 0
            player_9 0
            player_10 0
        }
    }
}'''

config = re.sub(r'themes \{.*?\n\}', new_theme, config, flags=re.DOTALL)
config = re.sub(r'theme \".*?\"', 'theme \"$THEME_NAME\"', config)
open('$ZELLIJ', 'w').write(config)
"
    echo "[ok] Zellij theme: $THEME_NAME"
fi

echo "================================"
echo "Done! Restart your tools to see changes."
echo "Helix theme is set in config, no restart needed for new files."
