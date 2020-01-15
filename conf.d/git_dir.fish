##
## Git directory
##

function check_and_setup_git_directory
    if git_is_repo
        function commit     --wraps "git commit";   git commit $argv; end
        function checkout   --wraps "git checkout"; git checkout $argv; end
        function pull       --wraps "git pull";     git pull $argv; end
        function push       --wraps "git push";     git push $argv; end
        function fetch      --wraps "git fetch";    git fetch $argv; end
        function stash      --wraps "git stash";    git stash $argv; end
        function add        --wraps "git add";      git add $argv; end
    else
        functions --erase commit
        functions --erase checkout
        functions --erase pull
        functions --erase push
        functions --erase fetch
        functions --erase stash
        functions --erase add
    end
end
