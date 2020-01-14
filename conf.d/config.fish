##
## Fish Config
##

# disable welcome message
function fish_greeting; end

# load custom extensions
source /etc/fish/conf.d/exit_status.fish
source /etc/fish/conf.d/git_dir.fish

# checks if a given string ends with another string
function string_ends_with
    string match -i --regex '^.*\.'"$argv[2]"'$' "$argv[1]" 2>&1 >/dev/null
end

# custom command not found handler
function __fish_command_not_found_handler --on-event fish_command_not_found

    # open audio and video files directly in mpv in current working directory
    if string_ends_with "$argv[1]" mkv; or \
       string_ends_with "$argv[1]" flac; or \
       string_ends_with "$argv[1]" wav
        mpv $argv

    # command not found
    else
        echo "$argv[1]: コマンドが見つかりません" >&2
    end
end

# load prompt
source /etc/fish/conf.d/prompt.fish
function fish_prompt
    set -g last_status $status
    printf "\033[0m\033[?25h" # reset terminal
    fish_load_custom_prompt
    check_and_setup_git_directory
end

# load aliases
source /etc/fish/conf.d/aliases.fish
source /etc/fish/conf.d/accesspoint.fish

# custom keybindings
function fish_user_key_bindings
    #bind \cl clear
end
