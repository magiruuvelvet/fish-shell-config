##
## fish config version
##

# changing this variable hot reloads currently running fish shells on "fish_prompt"
set -g fish_config_revision "24.2"

# TODO: "exec fish" not working in here, prints error about tty is 0x0 in size
function __fish_config_reload_if_different
    if [ "$fish_config_revision" != "$fish_config_revision_current" ]
        echo -e "\n"
        set_color --bold 2e6f87
        echo -n "  notice: the config has changed, please run 'exec fish' to apply them"
        set_color normal
        echo -e "\n"

        # silence the warning once printed
        set -g fish_config_revision_current "$fish_config_revision"
    end
end
