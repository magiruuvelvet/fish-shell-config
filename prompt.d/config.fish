##
## Prompt Data
##

set FISH_CONFIG_WHOAMI (whoami)
set FISH_CONFIG_HOSTNAME (hostname)
set FISH_CONFIG_USERNAME (awk -F":" '{ print $1$5 }' /etc/passwd | grep "$FISH_CONFIG_WHOAMI" | sed "s/^$FISH_CONFIG_WHOAMI//" | tr -d ',')
set FISH_CONFIG_USERNAME_LENGTH (__string_column_width "$FISH_CONFIG_USERNAME")
set FISH_CONFIG_HOSTNAME_LENGTH (string length "$FISH_CONFIG_HOSTNAME")
set FISH_REAL_CLEAR (which clear)
set FISH_CURRENT_TTY (tty | sed 's/^\/dev\///')

function __fish_prompt_header_username_setter
    if [ "$FISH_CONFIG_WHOAMI" = "root" ]
        echo ""
    else
        echo "$FISH_CONFIG_USERNAME@"
    end
end

set FISH_HEADER_USERNAME (__fish_prompt_header_username_setter)
set FISH_HEADER_USERNAME_LENGTH (__string_column_width "$FISH_HEADER_USERNAME")

set FISH_PREVIOUS_DIRECTORY ""

# fills the given length with character
# first stores everything in a variable,
# than prints everything at once, instead
# of spamming printf, which is slower
function fill_width
    set -l sep ""
    for CHAR in (seq $argv[1])
        set sep "$sep$argv[2]"
    end
    printf "$sep"
end

# get number of files in current directory
function __fish_prompt_get_pwd_inodes
    echo (ls | wc -l | tr -d '[:blank:]')
end
function __fish_prompt_get_pwd_inodes_all
    echo (ls -A | wc -l | tr -d '[:blank:]')
end
