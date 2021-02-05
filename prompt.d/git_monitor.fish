function git_repo_check
    set -l disable_walker 0

    if [ -f /etc/fish/private/git_config.fish ]
        source /etc/fish/private/git_config.fish
        # function printing 0 or 1, determines if commits should be counted or not
        if functions -q __git_config_disable_walker
            set disable_walker (__git_config_disable_walker (pwd))
        end
    end

    set -g git_repo_status (/etc/fish/bin/git-prompt-status (pwd) 0 $disable_walker 2>/dev/null)
    set -g git_repo_present 1

    if [ $status = 0 ]
        return 0
    else
        set -e git_repo_status
        set -e git_repo_present
        return 1
    end
end

## git monitor
function fish_prompt_git_monitor

    # ORDER OF ITEMS
    # 1 empty false
    # 2 bare false
    # 3 head_unborn false
    # 4 head_detached false
    # 5 hash be3f66e19f65a833d3a4c677abf2aa8b86cdf81b
    # 6 hash_short be3f66e1
    # 7 branch_name master
    # 8 branch_type branch
    # 9 untracked_files 0
    # 10 modified_files 0
    # 11 deleted_files 0
    # 12 clean false
    # 13 commits 71
    # 14 ahead_commits 0
    # 15 behind_commits 0
    # 16 diverged_history false
    # 17 has_remote_tracking_branch true
    set -l git_empty $git_repo_status[1]
    set -l git_bare $git_repo_status[2]
    set -l git_head_unborn $git_repo_status[3]
    set -l git_head_detached $git_repo_status[4]
    set -l git_hash $git_repo_status[5]
    set -l git_hash_short $git_repo_status[6]
    set -l git_branch_name $git_repo_status[7]
    set -l git_branch_type $git_repo_status[8]
    set -l git_untracked_files $git_repo_status[9]
    set -l git_modified_files $git_repo_status[10]
    set -l git_deleted_files $git_repo_status[11]
    set -l git_clean $git_repo_status[12]
    set -l git_commits $git_repo_status[13]
    set -l git_ahead_commits $git_repo_status[14]
    set -l git_behind_commits $git_repo_status[15]
    set -l git_diverged_history $git_repo_status[16]
    set -l git_has_remote_tracking_branch $git_repo_status[17]

    # initial length
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 0

    # check if repo is empty and print it as such
    if [ "$git_empty" = "true" ]
        set_color 919191
        printf "[empty git repository]"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+24)

    # repository has a history
    else
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+4)

        # branch name
        set -l git_stats $git_branch_name
        set -l git_branch_icon ""
        if [ "$git_head_detached" = "true" ]
            set_color --italic 2282b5
            set git_branch_icon "\ue728"
        else
            set_color b522b5
            set git_branch_icon "\ue725"
        end
        printf "$git_branch_icon $git_stats"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+2)

        printf " ("

        # short commit hash
        set -l git_stats $git_hash_short
        set_color 7f7f32
        printf $git_stats
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+5)
        set_color normal

        printf ")\e[1m [\e[0m"

        # commit count
        set -l git_stats $git_commits
        set_color ae81ae
        printf "\uf417$git_stats"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)

        # print remote branch difference when current branch has a remote
        if [ "$git_has_remote_tracking_branch" = "true" ]

        printf "\e[1m|\e[0m"

        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH + 1)

        set pushable $git_ahead_commits
        set pullable $git_behind_commits

        set -l git_stats "$pushable↑$pullable↓"
        set_color 19861d #9118a6
        set_color --background f2fff3
        printf "$pushable"
        set_color --bold 19861d #9118a6
        printf "⬆ " #"↑"
        set_color 398ea7 #ca70ca
        set_color --background f6fbfd
        printf "$pullable"
        set_color --bold 398ea7 #ca70ca
        printf "⬇ " #"↓"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+2)

        # check if local and remote have a different history
        if [ "$git_diverged_history" = "true" ]
            set_color --bold e80003
            set_color --background fdf3f3
            printf "〜"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
        end

        end # end remote repository difference

        printf "\e[1m]\e[0m "

        # is clean? show checkmark if so
        if [ "$git_clean" = "true" ]
            set -l git_stats " "
            set_color --bold 087f00
            printf "\uf00c"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has changed files?
        if [ "$git_modified_files" != "0" -o "$git_deleted_files" != "0" ]
            set changed_files_count (math $git_modified_files + $git_deleted_files)
            set -l git_stats " [$changed_files_count]"
            set_color --bold b89354
            printf "\ufbae"
            set_color normal
            set_color b89354
            printf "[$changed_files_count]"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has untracked files?
        set -l untracked_files_count $git_untracked_files
        if [ $untracked_files_count != 0 ]
            set -l git_stats " [$untracked_files_count]"
            set_color --bold 4d9be8
            printf "\uf457"
            set_color normal
            set_color 4d9be8
            printf "[$untracked_files_count]"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has stashed files?
        set -l stashed_count (git --no-pager stash list --decorate=short --pretty=oneline | wc -l)
        if [ "$stashed_count" != 0 ]
            set -l git_stats " [$stashed_count]"
            set_color --bold 3d7eba
            printf "\uf475"
            set_color normal
            set_color 3d7eba
            printf "[$stashed_count]"
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # show most used programming language
        __enry_get_language
    end
end
