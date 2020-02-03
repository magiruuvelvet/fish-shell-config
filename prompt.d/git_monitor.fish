## git monitor
function fish_prompt_git_monitor

    # initial length
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH 0

    # check if repo is empty and print it as such
    if git_is_empty
        set_color 919191
        printf "[empty git repository]"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+24)

    # repository has a history
    else
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+6)
        printf "\e[1m[\e[0m"

        # branch name
        set -l git_stats (git_branch_name)
        set_color b522b5
        printf "\ue725 $git_stats"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+2)

        printf " ("

        # short commit hash
        set -l git_stats (git rev-parse --short=8 HEAD)
        set_color 7f7f32
        printf $git_stats
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+5)
        set_color normal

        printf ")\e[1m] [\e[0m"

        # commit count
        set -l git_stats (git rev-list HEAD --count)
        set_color ae81ae
        printf "\uf417$git_stats"
        set_color normal
        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)

        # print remote branch difference when repository has a remote
        if [ (git remote -v | wc -l) != 0 ]

        printf "\e[1m|\e[0m"

        set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH + 1)

        # cache `git status` output for multiple use
        set -l git_status_output (git status)

        set pushable (echo {\n$git_status_output} | grep ahead | grep -o -E '[0-9]+ commit(s?)' | awk '{ print $1 }')
        set pullable (echo {\n$git_status_output} | grep behind | grep -o -E '[0-9]+ commit(s?)' | awk ' { print $1 }')

        if [ "$pushable" = "" ]
            # get diverged count on empty difference
            set pushable (echo {\n$git_status_output} | grep -A 1 diverged | tail -1 | awk '{ print $3 }')
            if [ "$pushable" = "" ]
                set pushable 0
            end
        end
        if [ "$pullable" = "" ]
            # get diverged count on empty difference
            set pullable (echo {\n$git_status_output} | grep -A 1 diverged | tail -1 | awk '{ print $5 }')
            if [ "$pullable" = "" ]
                set pullable 0
            end
        end

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
        set -l git_stats (git_ahead " " " " "〜" " ")
        if [ "$git_stats" = "〜" ]
            set_color --bold e80003
            set_color --background fdf3f3
            printf $git_stats
            set_color normal
            set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+(string length $git_stats)+1)
        end

        end # end remote repository difference

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
        set -l untracked_files_count (git_untracked_files)
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
        if git_is_stashed
            set stashed_count (git --no-pager stash list --decorate=short --pretty=oneline | wc -l)
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
