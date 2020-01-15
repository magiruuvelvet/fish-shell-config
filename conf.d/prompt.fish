##
## Prompt
##

# prompt dependencies
source /etc/fish/conf.d/enry.fish
source /etc/fish/conf.d/xdg.fish

# delete prompt pwd limit
set -g fish_prompt_pwd_dir_length 0

##
## Prompt Data
##
set FISH_CONFIG_WHOAMI (whoami)
set FISH_CONFIG_HOSTNAME (hostname)
set FISH_CONFIG_USERNAME (awk -F":" '{ print $1$5 }' /etc/passwd | grep "$FISH_CONFIG_WHOAMI" | sed "s/^$FISH_CONFIG_WHOAMI//" | tr -d ',')
set FISH_CONFIG_USERNAME_LENGTH (/usr/local/lib/bashrc-tools/strcolumns "$FISH_CONFIG_USERNAME")
set FISH_CONFIG_HOSTNAME_LENGTH (string length "$FISH_CONFIG_HOSTNAME")
set FISH_REAL_CLEAR (which clear)
set FISH_CURRENT_TTY (tty | sed 's/^\/dev\///')

function fish_prompt_header_username_setter
    if [ "$FISH_CONFIG_WHOAMI" = "root" ]
        echo ""
    else
        echo "$FISH_CONFIG_USERNAME@"
    end
end

set FISH_HEADER_USERNAME (fish_prompt_header_username_setter)
set FISH_HEADER_USERNAME_LENGTH (/usr/local/lib/bashrc-tools/strcolumns "$FISH_HEADER_USERNAME")

set FISH_PREVIOUS_DIRECTORY ""

# fills the given length with character
function fill_width
    set -l sep ""
    for CHAR in (seq $argv[1])
        set sep "$sep$argv[2]"
    end
    printf "$sep"
end

# get number of files in current directory
function fish_promp_get_pwd_inodes
    echo (ls | wc -l | tr -d '[:blank:]')
end
function fish_promp_get_pwd_inodes_all
    echo (ls -A | wc -l | tr -d '[:blank:]')
end

##
## Prompt Header
##
function fish_prompt_header
    # initial length of prompt
    set -l prompt_len (math 15+$FISH_HEADER_USERNAME_LENGTH+$FISH_CONFIG_HOSTNAME_LENGTH)

    # prompt header begin - contains redraw glitch fix
    printf "          \n┌───[ "

    # print full username with hostname
    printf $FISH_HEADER_USERNAME
    set_color --bold b1321c
    printf $FISH_CONFIG_HOSTNAME
    set_color normal

    # prompt header end
    printf " ]───"

    # get current time
    set -l current_date (date +"%H時%M分%S秒")
    set -l current_date_len (/usr/local/lib/bashrc-tools/strcolumns "$current_date")
    set -l prompt_len (math $prompt_len+$current_date_len)

    fill_width (math $COLUMNS-$prompt_len) "─"

    # print current time
    printf "["
    set_color --bold 565656
    printf $current_date
    set_color normal

    # header line end
    printf "]─┐\n"
end

##
## Prompt working directory stats
##
function fish_prompt_directory_stats
    printf "│ "

    # print last exit status
    printf "["
    if [ $last_status != 0 ]
        set_color b1321c
    end
    if [ $last_status -ge 126 -a $last_status -le 128 ]
        set_color -b 699d9d
        set_color ffffff
    end
    if [ $last_status -ge 129 -a $last_status -le 158 ]
        set_color -b b218b2
        set_color ffffff
    end
    set -l last_status (map_exit_status_to_signal_name $last_status)
    set -l last_status_len (string length $last_status)
    printf $last_status

    set_color normal
    printf "] CWD["

    # print number of files
    set -l cwd_inode_count (fish_promp_get_pwd_inodes)
    set -l cwd_invisible_inode_count (math (fish_promp_get_pwd_inodes_all)-$cwd_inode_count)

    printf $cwd_inode_count
    set -l cwd_inode_count (string length $cwd_inode_count)

    # print number of hidden files when available
    if [ $cwd_invisible_inode_count != 0 ]
        set_color d5d5d5
        printf /
        printf $cwd_invisible_inode_count
        set cwd_invisible_inode_count (math (string length $cwd_invisible_inode_count)+1)
        set_color normal
    else
        set cwd_invisible_inode_count 0
    end

    # print working directory
    printf "]: "
    printf (prompt_pwd)

    # get real length in columns of pwd (CJK)
    set -l pwd_length (/usr/local/lib/bashrc-tools/strcolumns (prompt_pwd))

    # total line length by now
    set -l line_len (math $cwd_inode_count+$cwd_invisible_inode_count+$pwd_length+$last_status_len+12+1)

    fill_width (math $COLUMNS-$line_len) " "

    # end of line
    printf "│\n"
end

##
## Prompt Extras
##
set FISH_PROMPT_LAST_LANGUAGE ""
set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0
set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 0

## git monitor
function fish_prompt_git_monitor

    # print that prompt is inside a git repository
    printf "│ "
    set_color cccccc
    printf "git:"
    set_color normal
    printf " "

    # initial length
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 7

    # check if repo is empty and print it as such
    if git_is_empty
        set_color 919191
        printf "[empty repository]"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+18)

    # repository has a history
    else
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+6)
        printf "["

        # branch name
        set -l git_stats (git_branch_name)
        set_color b522b5
        printf $git_stats
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))

        printf "|"

        # print remote branch difference
        set pushable (git status | grep ahead | grep -o -E '[0-9]+ commit(s?)' | awk '{ print $1 }')
        set pullable (git status | grep behind | grep -o -E '[0-9]+ commit(s?)' | awk ' { print $1 }')
        if [ "$pushable" = "" ]
            set pushable 0
        end
        if [ "$pullable" = "" ]
            set pullable 0
        end

        set -l git_stats "$pushable↑$pullable↓"
        set_color 9118a6
        printf "$pushable"
        set_color --bold 9118a6
        printf "↑"
        set_color ca70ca
        printf "$pullable"
        set_color --bold ca70ca
        printf "↓"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))

        # check if local and remote have a different history
        set -l git_stats (git_ahead " " " " "~" " ")
        if [ "$git_stats" = "~" ]
            set_color --bold e80003
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        end

        printf "|"

        # short commit hash
        set -l git_stats (git rev-parse --short=7 HEAD)
        set_color 7f7f32
        printf $git_stats
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        set_color normal

        printf "] "

        # is dirty?
        if git_is_dirty
            set -l git_stats "dirty"
            set_color --bold b8b85b
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        else
            set -l git_stats "clean"
            set_color --bold 087f00
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        end

        printf " "

        # has changed files?
        if git_is_touched
            set -l git_stats "changed"
            set_color --bold b89354
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has untracked files?
        set -l untracked_files_count (git_untracked_files)
        if [ $untracked_files_count != 0 ]
            set -l git_stats "untracked[$untracked_files_count]"
            set_color --bold 4d9be8
            printf "untracked"
            set_color normal
            set_color 4d9be8
            printf "[$untracked_files_count]"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has stashed files?
        if git_is_stashed
            set -l git_stats "stashed"
            set_color --bold 4d9be8
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # show most used programming language
        if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
            # don't compute language on huge repositories, use predefined key value pair
            enry_check_cached (prompt_pwd)
            if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
                set FISH_PROMPT_LAST_LANGUAGE (timeout --foreground 1 "/etc/fish/enry" | head -1 | awk '{print $2}')
                if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
                    set FISH_PROMPT_LAST_LANGUAGE "(to)"
                else
                    set FISH_PROMPT_LAST_LANGUAGE_LENGTH (math (string length $FISH_PROMPT_LAST_LANGUAGE)+3)
                end
            end
        end
    end
end

## show last downloaded file
function fish_prompt_xdg_download_info
    # get latest modified file
    set -l last_download (ls -t | head -1)
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (/usr/local/lib/bashrc-tools/strcolumns "$last_download")
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+18)

    printf "│ "
    set_color cccccc
    printf "最新のファイル:"
    set_color normal
    printf " $last_download"
end

## main extra function
function fish_prompt_extras
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 2

    # check if directory changed
    if [ "$FISH_PREVIOUS_DIRECTORY" != (prompt_pwd) ]
        set FISH_PREVIOUS_DIRECTORY (prompt_pwd)
        set FISH_PROMPT_LAST_LANGUAGE ""
        set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0
    end

    # git repository
    if git_is_repo
        fish_prompt_git_monitor

    else if dir_is_xdg_download
        fish_prompt_xdg_download_info

    # default, no extras found for directory
    else
        printf "│ "
    end

    # fill width
    set -l tty_len (string length $FISH_CURRENT_TTY)
    fill_width (math $COLUMNS-$FISH_PROMPT_EXTRAS_TOTAL_LENGTH-2-$tty_len-2-$FISH_PROMPT_LAST_LANGUAGE_LENGTH) " "

    # print extras
    if [ "$FISH_PROMPT_LAST_LANGUAGE" != "" -a "$FISH_PROMPT_LAST_LANGUAGE" != "(to)" ]
        printf "["
        enry_print_language "$FISH_PROMPT_LAST_LANGUAGE"
        printf "]─"
    end

    # print current tty
    printf "[$FISH_CURRENT_TTY]─┘\n"
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
function fish_load_custom_prompt
    fish_prompt_header
    fish_prompt_directory_stats
    fish_prompt_extras
    fish_prompt_input_line
end

# full clear without regrets, nukes terminal emulator scrollback
function clear
    echo -e "\033c\e[3J"
    "$FISH_REAL_CLEAR"
    printf "\e[3J"
end
