# complete arguments to wrapper command as dedicated command
function __fish_complete_wrapper_command_subcommand
    __fish_complete_subcommand --commandline "$argv"
end

# list of wrapper commands to forward completions
complete -c "vpn-run" -x -a "(__fish_complete_wrapper_command_subcommand)"
complete -c "primerun" -x -a "(__fish_complete_wrapper_command_subcommand)"
complete -c "primusrun" -x -a "(__fish_complete_wrapper_command_subcommand)"
complete -c "optirun" -x -a "(__fish_complete_wrapper_command_subcommand)"
complete -c "mangohud" -x -a "(__fish_complete_wrapper_command_subcommand)"
complete -c "primerun-hud" -x -a "(__fish_complete_wrapper_command_subcommand)"

complete -c "offline" -x -a "(__fish_complete_wrapper_command_subcommand)"
