##
## Prompt working directory stats
##

function fish_prompt_directory_stats
    if [ "$FISH_CONFIG_WHOAMI" = "root" ]
        printf "│\e[1m\e[38;2;182;0;0m▌\e[0m"
    else
        printf "│ "
    end

    # print last exit status
    printf "["
    if [ $last_status != 0 ]
        set_color b1321c
    end
    if [ $last_status -ge 125 -a $last_status -le 128 ]
        set_color -b 699d9d
        set_color ffffff
    end
    if [ $last_status -ge 129 -a $last_status -le 158 ]
        set_color -b b218b2
        set_color ffffff
    end
    set -l last_status (__map_exit_status_to_signal_name $last_status)
    set -l last_status_len (string length $last_status)
    printf $last_status

    set_color normal
    printf "]["

    # print number of files
    set -l cwd_inode_count (__fish_prompt_get_pwd_inodes)
    set -l cwd_invisible_inode_count (math (__fish_prompt_get_pwd_inodes_all)-$cwd_inode_count)

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
    set -l pwd_length (__string_column_width (prompt_pwd))

    # total line length by now
    set -l line_len (math $cwd_inode_count+$cwd_invisible_inode_count+$pwd_length+$last_status_len+9)

    fill_width (math $COLUMNS-$line_len) " "

    # end of line
    printf "│\n"
end
