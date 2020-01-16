##
## enhancd
##

set -gx ENHANCD_ROOT "/etc/fish/functions/enhancd"
set -gx ENHANCD_DIR "$HOME/.enhancd"

set -gx ENHANCD_FILTER "fzy"
set -gx ENHANCD_COMMAND "cd"
set -gx ENHANCD_DISABLE_DOT 0
set -gx ENHANCD_DISABLE_HYPHEN 0
set -gx ENHANCD_DISABLE_HOME 0
set -gx ENHANCD_DOT_ARG "..." # ".." to just go back one level without selection
set -gx ENHANCD_HYPHEN_ARG "-"
set -gx ENHANCD_HYPHEN_NUM 10
set -gx ENHANCD_HOME_ARG ""
set -gx ENHANCD_USE_FUZZY_MATCH 1

# completion config
set -gx ENHANCD_COMPLETION_DEFAULT 1
set -gx ENHANCD_COMPLETION_BEHAVIOUR "default"
set -gx ENHANCD_COMPLETION_KEYBIND "^I";

# set -gx ENHANCD_HOOK_AFTER_CD "ll"

set -gx _ENHANCD_VERSION "2.2.4"
set -gx _ENHANCD_SUCCESS 0
set -gx _ENHANCD_FAILURE 60

# ensure enhancd directory exists
if ! [ -d "$ENHANCD_DIR" ]; mkdir -p "$ENHANCD_DIR"; end
if ! [ -f "$ENHANCD_DIR/enhancd.log" ]; echo "/" >> "$ENHANCD_DIR/enhancd.log"; end

# use enhancd as default cd command
eval "alias $ENHANCD_COMMAND 'enhancd'"

# go back with selection
alias ...='enhancd ...'

# navigation shortcuts
alias .='cd .'     # "." is deprecated in fish and scheduled for deletion in a future release
alias ..='cd ..'   # works without alias in fish, but make sure the cd command is explicitly used
