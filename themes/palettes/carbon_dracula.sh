# carbon_dracula - space_carbon structure + Dracula accents
# Black background and layered grays from Carbon, vivid Dracula foreground accents.

THEME_NAME="carbon_dracula"
HELIX_THEME="carbon_dracula"

# Base
BG="#000000"
FG="#c1c9d2"
CURSOR="#c1c9d2"
SELECTION_BG="#44475a"
SELECTION_FG="#f8f8f2"

# Normal colors (Dracula)
BLACK="#000000"
RED="#ff5555"
GREEN="#1ea672"
YELLOW="#f1fa8c"
BLUE="#bd93f9"
MAGENTA="#ff79c6"
CYAN="#8be9fd"
WHITE="#f8f8f2"

# Bright colors
BRIGHT_BLACK="#6272a4"
BRIGHT_RED="#ff6e6e"
BRIGHT_GREEN="#85d996"
BRIGHT_YELLOW="#ffffa5"
BRIGHT_BLUE="#d6acff"
BRIGHT_MAGENTA="#ff92df"
BRIGHT_CYAN="#a4ffff"
BRIGHT_WHITE="#ffffff"

# Dark/muted variants (for backgrounds, subtle highlights)
DARK_RED="#3d1a1a"
DARK_GREEN="#1a3d24"
DARK_YELLOW="#3d331a"
DARK_BLUE="#2a1a3d"
DARK_MAGENTA="#3d1a33"
DARK_CYAN="#1a333d"
DARK_WHITE="#282a36"

# Layered surfaces: black -> dracula panel
BG1="#0c0c0c"
BG2="#161616"
BG3="#21222c"
BG4="#44475a"

# Additional accents
ORANGE="#ffb86c"
PINK="#ff79c6"
TEAL="#8be9fd"

# Semantic
ACCENT="$CYAN"
SUCCESS="$GREEN"
WARNING="$YELLOW"
ERROR="$RED"
INFO="$BLUE"
MUTED="$BRIGHT_BLACK"
# Panels and the compact bar share the terminal background (tmux-like)
SURFACE="$BG"

# Ribbon / tab bar: no backgrounds at all, only text color changes
RIBBON_BG="0"
RIBBON_SELECTED_BG="0"
RIBBON_SELECTED_FG="$GREEN"
RIBBON_UNSELECTED_FG="$MUTED"
# zellij also uses ribbon_hover for every alternate tab, so keep it identical
# to unselected: all inactive tabs look the same until hovered/active
RIBBON_HOVER_BG="0"
RIBBON_HOVER_FG="$MUTED"
