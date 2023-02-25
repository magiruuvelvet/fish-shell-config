
# get additional command line options for the git prompt component
function __fish_git_prompt_options
    if [ "$FISH_PROMPT_GIT_ENABLED" = "0" ]
        set -g git_repo_present 0
        set -a __fish_shell_prompt_options "--git-prompt-disable"
    else
        if [ -f /etc/fish/private/git_config.fish ]
            source /etc/fish/private/git_config.fish

            # function printing 0 or 1, determines if the git prompt should be loaded or not
            if functions -q __git_config_disable_status
                if [ (__git_config_disable_status (pwd)) = "1" ]
                    set -g git_repo_present 0
                    set -a __fish_shell_prompt_options "--git-prompt-disable"
                end
            end

            # function printing 0 or 1, determines if commits should be counted or not
            if functions -q __git_config_disable_walker
                if [ (__git_config_disable_walker (pwd)) = "1" ]
                    set -a __fish_shell_prompt_options "--git-prompt-disable-commit-counting"
                end
            end
        end
    end
end

# prompt main function
function fish_prompt_main
    # clear additional arguments array
    __fish_shell_prompt_options_setup

    # assume git is available by default
    set -g git_repo_present 1

    # get additional command line options for the git prompt component
    __fish_git_prompt_options

    # disable git repository probing when it was already disabled by the above check
    if [ "$git_repo_present" != 0 ]
        set -g git_repo_present ("$SHELL_PROMPT_BINARY" --git-probe-repository)
    end

    # use a different line terminator when path-aware-aliases are available
    if __path_aware_aliases_present
        set -l __fish_shell_prompt_line_terminator (printf "\e[1m\e[38;2;73;140;63m>>\e[0m ")
        set -a __fish_shell_prompt_options "--input-line-terminator=$__fish_shell_prompt_line_terminator"
    end

    __fish_shell_prompt_launch
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

    # requires patched fish shell, reset status to zero on clear
    set status 0 >/dev/null 2>&1 || true
end

function __list_files
    printf "\n"

    if [ (commandline) = "" ]
        ls --color -lla
    else
        ls --color -lla | egrep -i (commandline)
    end

    printf "\n\n\n\n\n" # number of visible prompt lines (first newline in prompt is ignored)
    commandline -f repaint
end
