##
## Prompt
##

# delete prompt pwd limit
set -g fish_prompt_pwd_dir_length 0

source "$FISH_CONFIG_PREFIX/prompt.d/config.fish"
source "$FISH_CONFIG_PREFIX/prompt.d/header.fish"
source "$FISH_CONFIG_PREFIX/prompt.d/cwd.fish"

##
## Prompt Extras
##
set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 0
source "$FISH_CONFIG_PREFIX/prompt.d/git_monitor.fish"
source "$FISH_CONFIG_PREFIX/prompt.d/download.fish"
source "$FISH_CONFIG_PREFIX/prompt.d/ssh.fish"

function __fish_prompt_last_command_ssh
    printf "\e[1mssh: welcome back home :)\e[0m"
    set -g LAST_COMMAND_SSH 0
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 27
end

## main extra function
function fish_prompt_extras
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 2

    # check if directory changed and reset directory states
    if [ "$FISH_PREVIOUS_DIRECTORY" != (prompt_pwd) ]
        set FISH_PREVIOUS_DIRECTORY (prompt_pwd)
        __enry_reset_state
    end

    if [ "$FISH_CONFIG_WHOAMI" = "root" ]
        printf "│\e[1m\e[38;2;182;0;0m▌\e[0m"
    else
        printf "│ "
    end

    # last command was ssh
    if [ "$LAST_COMMAND_SSH" = 1 ]; __fish_prompt_last_command_ssh
    # git repository: show git monitoring prompt
    else if git_is_repo; fish_prompt_git_monitor
    # download directory: show last downloaded file for copy paste
    else if __dir_is_xdg_download; __fish_prompt_xdg_download_info
    # ssh config directory: print command how to generate a new key
    else if __dir_is_ssh_config; __fish_prompt_ssh_info
    end

    # detect build system of current directory and show it
    # looks for the existence of specific files
    set -l build_system (__detect_build_system)
    set -l build_system_len (math (string length $build_system) + 3)
    [ "$build_system" = "" ] && set build_system_len 0

    fill_width (math $COLUMNS-$FISH_PROMPT_EXTRAS_TOTAL_LENGTH-2-$FISH_PROMPT_LAST_LANGUAGE_LENGTH-$build_system_len) " "

    # print detected programming language
    __enry_print_language

    # print the detected build system
    __print_build_system "$build_system"

    printf "─┘\n"
end

##
## Prompt Input Line
##
function fish_prompt_input_line
    printf "└─"

    set -l prompt_input_line_end "# "
    if [ "$FISH_CONFIG_WHOAMI" = "root" ]
        set prompt_input_line_end (printf "\e[1m\e[38;2;182;0;0m\$\e[0m ")
    end

    if [ ! -z "$VPNSHELL" ]
        set_color a500a5
        printf "(vpn)"
        set_color normal
    end

    printf "$prompt_input_line_end"
end

##
## Prompt Main Function
##
function fish_prompt_main
    fish_prompt_header
    fish_prompt_directory_stats
    fish_prompt_extras
    fish_prompt_input_line
end

# full clear without regrets, nukes terminal emulator scrollback
function clear
    echo -e "\033c\e[3J"
    command clear
    printf "\e[3J"
end

# clears the entire command line
function __clear_commandline
    commandline ""
end

# full clear and repaint
function __clear_full
    commandline ""
    echo -e "\033c\e[3J"
    command clear
    printf "\e[3J"
    commandline -f repaint
    set -g status_reset 1
end
