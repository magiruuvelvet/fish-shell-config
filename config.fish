##
## Fish Config
##

# ignore this configuration file when not running in interactive mode
# to ensure a clean vanilla fish shell environment
if status is-interactive

set -gx SHELL /bin/fish
set -gx FISH_CONFIG_PREFIX /etc/fish

# check which version the current fish instance is using
source "$FISH_CONFIG_PREFIX/version.fish"
# current instance version
set -g fish_config_revision_current "$fish_config_revision"

# load default aliases
source "$FISH_CONFIG_PREFIX/aliases.fish"

# note: fish autoloads everything in conf.d/
#       which breaks my overengineered prompt :(
#       use custom directories instead
# note 2: wildcard sourcing doesn't seem to work

# disable welcome message (may be useful though for SSH when I install fish on my servers)
function fish_greeting; end

# checks if a given string ends with another string
function string_ends_with
    string match -i --regex '^.*'"$argv[2]"'$' "$argv[1]" >/dev/null 2>&1
end

# checks if a given string starts with another string
function string_starts_with
    string match -i --regex '^'"$argv[2]"'.*$' "$argv[1]" >/dev/null 2>&1
end

# sources an entire directory tree of .fish scripts
function source-recursive
    if [ -d "$argv[1]" ]
        for file in (find "$argv[1]" -type f -iname '*.fish')
            source "$file"
        end
    end
end

# load custom extensions
source "$FISH_CONFIG_PREFIX/functions.d/build_system.fish"
source "$FISH_CONFIG_PREFIX/functions.d/dirs.fish"
#source "$FISH_CONFIG_PREFIX/functions.d/enhancd.fish"
source "$FISH_CONFIG_PREFIX/functions.d/enry.fish"
source "$FISH_CONFIG_PREFIX/functions.d/exit_status.fish"
source "$FISH_CONFIG_PREFIX/functions.d/git.fish"
source "$FISH_CONFIG_PREFIX/functions.d/language_color.fish"
source "$FISH_CONFIG_PREFIX/functions.d/strcolumns.fish"
source "$FISH_CONFIG_PREFIX/functions.d/xdg.fish"
source "$FISH_CONFIG_PREFIX/functions.d/path-aware-aliases.fish"

# load the fuck when installed
#if which thefuck >/dev/null 2>&1
#    thefuck --alias f | source
#end

# custom command not found handler
function __fish_command_not_found_handler --on-event fish_command_not_found

    # open audio and video files directly in mpv in current working directory
    if string_ends_with "$argv[1]" '\.mkv'; or \
       string_ends_with "$argv[1]" '\.flac'; or \
       string_ends_with "$argv[1]" '\.wav'
        mpv $argv

    # command not found
    else
        echo "$argv[1]: コマンドが見つかりません" >&2
    end
end

# load prompt
source "$FISH_CONFIG_PREFIX/prompt.d/prompt.fish"
function fish_prompt
    # store last application exit status
    set -g last_status $status

    # reset status to zero when using the clear shortcut
    if [ "$status_reset" = 1 ]
        set -g last_status 0
        set -g status_reset 0
    end

    # reload current directory and print a warning when it was deleted
    builtin cd . >/dev/null 2>&1
    if [ $status != 0 ]
        echo
        set_color --bold f90004
        echo -n "  warning: directory deleted! executing commands may cause undefined behavior."
        set_color normal
        echo
    end

    # run custom function
    if functions -q fish_prompt_custom
        fish_prompt_custom
    end

    # reset terminal to previous state
    # (for broken applications which don't clean up
    #  their escape sequences or do weird things to
    #  the terminal emulator and forgot to restore them)
    printf "\033[0m\033[?25h"

    # check version
    source "$FISH_CONFIG_PREFIX/version.fish"
    __fish_config_reload_if_different

    # main prompt function
    fish_prompt_main

    # prompt post processing
    __check_and_setup_git_directory
end

# function fish_right_prompt
# end

# function fish_prompt_preexec --on-event fish_preexec
# end

function fish_prompt_postexec --on-event fish_postexec
    set -l index 1
    set -l command_length 0
    for char in (echo "$argv[1]" | string split "")
        if [ "$char" = " " ]
            set command_length (math $index - 1)
            break
        end
        set index (math $index + 1)
    end
    set -g last_command (string sub "$argv[1]" -l $command_length)

    if functions -q __last_command_handler
        __last_command_handler "$argv"
    end
end

# function __trigger_prompt_sync --on-event fish_prompt
#     set -U __prompt_sync $PWD
# end
#
# function __prompt_sync --on-variable __prompt_sync
#     test $PWD = $__prompt_sync; or return
#     commandline -f repaint
# end

# su wrapper with fish fork hint
function su
    # hint to exec fish after sourcing the environment
    set -x FISH_SU true
    command su $argv
end

# load private configurations
if [ -d "$FISH_CONFIG_PREFIX/private" ]
    source-recursive "$FISH_CONFIG_PREFIX/private"
end

# custom keybindings
function fish_user_key_bindings
    bind \cl __clear_full        # Ctrl+L ("clear" command, but as keyboard shortcut)

    bind \cc __clear_commandline # Ctrl+C
    bind \cu __clear_commandline # Ctrl+U
    bind \cx __list_files        # Ctrl+X

    if functions -q __custom_user_key_bindings
        __custom_user_key_bindings
    end
end

# load all completions
source "$FISH_CONFIG_PREFIX/completions/wrapper_commands.fish"

# call initial path-aware-aliases setup
# --on-variable PWD is not triggered on shell initialization
__path_aware_aliases_setup

end # is-interactive
