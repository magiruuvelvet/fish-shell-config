##
## Prompt Header
##

function fish_prompt_header
    # initial length of prompt
    set -l prompt_len (math 13+$FISH_HEADER_USERNAME_LENGTH+$FISH_CONFIG_HOSTNAME_LENGTH)

    # prompt header begin
    printf "\n┌───["

    # print full username with hostname
    printf $FISH_HEADER_USERNAME
    if [ ! -z "$FISH_CONFIG_HOSTNAME_COLOR" ]
        printf "$FISH_CONFIG_HOSTNAME_COLOR"
    else
        printf "\e[1m\e[38;2;177;50;28m"
    end
    printf $FISH_CONFIG_HOSTNAME
    set_color normal

    # prompt header end
    printf "]───"

    # get current time
    set -l current_date (date +"時間%H:%M:%S")
    set -l current_date_len 12 #(__string_column_width "$current_date")
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
