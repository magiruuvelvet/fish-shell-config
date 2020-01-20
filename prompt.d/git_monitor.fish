## git monitor
function fish_prompt_git_monitor

    # print that prompt is inside a git repository
    printf "│ "
    set_color b3b3b3
    printf "git"
    set_color normal

    # initial length
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 5

    # check if repo is empty and print it as such
    if git_is_empty
        set_color 919191
        printf "[empty repository]"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+18)

    # repository has a history
    else
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+5)
        printf "\e[1m[\e[0m"

        # branch name
        set -l git_stats (git_branch_name)
        set_color b522b5
        printf $git_stats
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))

        printf "\e[1m|\e[0m"

        # print remote branch difference
        set pushable (git status | grep ahead | grep -o -E '[0-9]+ commit(s?)' | awk '{ print $1 }')
        set pullable (git status | grep behind | grep -o -E '[0-9]+ commit(s?)' | awk ' { print $1 }')

        if [ "$pushable" = "" ]
            # get diverged count on empty difference
            set pushable (git status | grep -A 1 diverged | tail -1 | awk '{ print $3 }')
            if [ "$pushable" = "" ]
                set pushable 0
            end
        end
        if [ "$pullable" = "" ]
            # get diverged count on empty difference
            set pullable (git status | grep -A 1 diverged | tail -1 | awk '{ print $5 }')
            if [ "$pullable" = "" ]
                set pullable 0
            end
        end

        set -l git_stats "$pushable↑$pullable↓"
        set_color 19861d #9118a6
        printf "$pushable"
        set_color --bold 19861d #9118a6
        printf "⬆ " #"↑"
        set_color 398ea7 #ca70ca
        printf "$pullable"
        set_color --bold 398ea7 #ca70ca
        printf "⬇ " #"↓"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+2)

        # check if local and remote have a different history
        set -l git_stats (git_ahead " " " " "~" " ")
        if [ "$git_stats" = "~" ]
            set_color --bold e80003
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        end

        printf "\e[1m|\e[0m"

        # short commit hash
        set -l git_stats (git rev-parse --short=8 HEAD)
        set_color 7f7f32
        printf $git_stats
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats))
        set_color normal

        printf "\e[1m]\e[0m "

        # is dirty?
        if ! git_is_dirty
            set -l git_stats "clean"
            set_color --bold 087f00
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
            printf " "
        end

        # has changed files?
        if git_is_touched
            set changed_files_count (git ls-files -m | wc -l)
            set -l git_stats "changed[$changed_files_count]"
            set_color --bold b89354
            printf "changed"
            set_color normal
            set_color b89354
            printf "[$changed_files_count]"
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
        __enry_get_language
    end
end
