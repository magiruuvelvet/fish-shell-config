# git directory features
function __check_and_setup_git_directory
    if [ "$git_repo_present" = 1 ]
        function commit     --wraps "git commit";   git commit $argv; end
        function checkout   --wraps "git checkout"; git checkout $argv; end
        function pull       --wraps "git pull";     git pull $argv; end
        function push       --wraps "git push";     git push $argv; end
        function fetch      --wraps "git fetch";    git fetch $argv; end
        function stash      --wraps "git stash";    git stash $argv; end
        function add        --wraps "git add";      git add $argv; end
        function branch     --wraps "git branch";   git branch $argv; end
        function sdiff      --wraps "git sdiff";    git sdiff $argv; end
        function diff       --wraps "git diff";     git diff $argv; end
        function tag        --wraps "git tag";      git tag $argv; end
        function stag       --wraps "git stag";     git stag $argv; end
        function slog       --wraps "git slog";     git slog $argv; end
        function ls-files   --wraps "git ls-files"; git ls-files $argv; end
        function remote     --wraps "git remote";   git remote $argv; end
        function reset      --wraps "git reset";    git reset $argv; end
        function visit;                           __git_url_visit $argv; end
    else
        functions --erase commit
        functions --erase checkout
        functions --erase pull
        functions --erase push
        functions --erase fetch
        functions --erase stash
        functions --erase add
        functions --erase branch
        functions --erase sdiff
        functions --erase diff
        functions --erase tag
        functions --erase stag
        functions --erase slog
        functions --erase ls-files
        functions --erase remote
        functions --erase reset
        functions --erase visit
    end
end

# normalize git url to http
function __git_url_convert
    set -l url "$argv[1]"

    if [ (string length $url) = 0 ]
        return 1
    end

    if string_starts_with "$url" "http"
        echo "$url"
        return 0
    else
        # convert ssh url to http url
        set -l domain_start 1
        set -l domain_end 1

        # find domain
        set -l index 1
        for char in (echo "$url" | string split "")
            if [ "$char" = "@" ]
                set domain_start (math $index + 1)
            else if [ "$char" = ":" ]
                set domain_end $index
            end
            set index (math $index + 1)
        end

        set -l domain (string sub $url -s $domain_start -l (math $domain_end - $domain_start))

        # find path
        set -l remaining_url (string sub $url -s (math $domain_end + 1))

        # print url
        echo "https://$domain/$remaining_url"
        return 0
    end
end

# visit git repositories in the default web browser
function __git_url_visit
    if [ (count $argv) = 0 ]
        set remote "origin"
    else
        set remote "$argv[1]"
    end

    set -l url (git remote get-url "$remote" 2>/dev/null)
    set -l url (__git_url_convert "$url")
    if [ $status = 0 ]
        xdg-open "$url" >/dev/null 2>&1
    else
        echo "エーラー: git repository has no remote '$remote'" >&2
    end
end
