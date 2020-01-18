##
## fish config version
##

# changing this variable hot reloads currently running fish shells on "fish_prompt"
set -g fish_config_revision "26.4"

function __fish_config_reload_if_different
    if [ "$fish_config_revision" != "$fish_config_revision_current" ]
        echo -e "\n"
        set_color --bold 2e6f87
        #echo -n "  notice: the config has changed, please run 'exec fish' to apply them"
        echo -n "  notice: the config has changed and was hot reloaded"
        set_color normal
        echo -e "\n"

        # update version of currently running instance
        set -g fish_config_revision_current "$fish_config_revision"

        # re-source config.fish
        source /etc/fish/config.fish
    end
end
