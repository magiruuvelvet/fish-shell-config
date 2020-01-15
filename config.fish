source /etc/fish/conf.d/config.fish

function su
    # hint to exec fish after sourcing the environment
    set -x FISH_SU true
    command su $argv
end

# load all completions
source /etc/fish/completions/*.fish
