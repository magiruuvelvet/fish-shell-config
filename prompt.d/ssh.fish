## print ssh keygen command
function __fish_prompt_ssh_info
    set_color 282828
    set -l info_line "[SSH] generate new key: 'ssh-keygen -f name -t rsa -b 4096'"
    printf "$info_line"
    set_color normal

    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math (string length $info_line)+2)
end
