##
## Prompt Header
##

function fish_prompt_header
    # initial length of prompt
    set -l prompt_len (math 15+$FISH_HEADER_USERNAME_LENGTH+$FISH_CONFIG_HOSTNAME_LENGTH)

    # prompt header begin - contains redraw glitch fix
    printf "          \n┌───[ "

    # print full username with hostname
    printf $FISH_HEADER_USERNAME
    set_color --bold b1321c
    printf $FISH_CONFIG_HOSTNAME
    set_color normal

    # prompt header end
    printf " ]───"

    # get current time
    set -l current_date (date +"%H時%M分%S秒")
    set -l current_date_len (/usr/local/lib/bashrc-tools/strcolumns "$current_date")
    set -l prompt_len (math $prompt_len+$current_date_len)

    fill_width (math $COLUMNS-$prompt_len) "─"

    # print current time
    printf "["
    set_color --bold 565656
    printf $current_date
    set_color normal

    # header line end
    printf "]─┐\n"
end
