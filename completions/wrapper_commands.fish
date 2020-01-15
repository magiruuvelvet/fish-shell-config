# complete arguments to wrapper command as dedicated command
function __fish_complete_wrapper_command_subcommand
    __fish_complete_subcommand --commandline "$argv"
end

# list of wrapper commands to forward completions
complete -c "vpn-run" -x -a "(__fish_complete_wrapper_command_subcommand)"
