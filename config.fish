##
## Fish Config
##

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
function source_recursive
    if [ -d "$argv[1]" ]
        for file in (find "$argv[1]" -type f -iname '*.fish')
            source "$file"
        end
    end
end

# load custom extensions
source /etc/fish/functions.d/build_system.fish
source /etc/fish/functions.d/dirs.fish
source /etc/fish/functions.d/enhancd.fish
source /etc/fish/functions.d/enry.fish
source /etc/fish/functions.d/exit_status.fish
source /etc/fish/functions.d/git_dir.fish
source /etc/fish/functions.d/git.fish
source /etc/fish/functions.d/language_color.fish
source /etc/fish/functions.d/xdg.fish

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
source /etc/fish/prompt.d/prompt.fish
function fish_prompt
    # store last application exit status
    set -g last_status $status

    # reset terminal to previous state
    # (for broken applications which don't clean up
    #  their escape sequences or do weird things to
    #  the terminal emulator and forgot to restore them)
    printf "\033[0m\033[?25h"

    # main prompt function
    fish_load_custom_prompt

    # prompt post processing
    check_and_setup_git_directory
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
end

# custom keybindings
function fish_user_key_bindings
    #bind \cl clear
end

# su wrapper with fish fork hint
function su
    # hint to exec fish after sourcing the environment
    set -x FISH_SU true
    command su $argv
end

# load private configurations
if [ -d /etc/fish/private ]
    source_recursive /etc/fish/private
end

# load all completions
source /etc/fish/completions/wrapper_commands.fish
