##
## Fish Config
##

# note: fish autoloads everything in conf.d/

# disable welcome message
function fish_greeting; end

# checks if a given string ends with another string
function string_ends_with
    string match -i --regex '^.*'"$argv[2]"'$' "$argv[1]" >/dev/null 2>&1
end

# checks if a given string starts with another string
function string_starts_with
    string match -i --regex '^'"$argv[2]"'.*$' "$argv[1]" >/dev/null 2>&1
end

# load custom extensions
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
    set -g last_status $status
    printf "\033[0m\033[?25h" # reset terminal
    fish_load_custom_prompt
    check_and_setup_git_directory
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
source /etc/fish/private/accesspoint.fish
source /etc/fish/private/aliases.fish

# load all completions
source /etc/fish/completions/wrapper_commands.fish
