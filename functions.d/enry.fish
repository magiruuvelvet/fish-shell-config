##
## Enry
##

# contains the __enry_check_cached function and user settings
source /etc/fish/private/enry_config.fish

function enry-enable
    set -g enry_enabled 1
    source /etc/fish/functions.d/enry.fish
end

function enry-disable
    set -g enry_enabled 0
    source /etc/fish/functions.d/enry.fish
end

# state variables for enry
set FISH_PROMPT_LAST_LANGUAGE ""
set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0

# check if a custom cache function was defined
if ! functions -q __enry_check_cached
    function __enry_check_cached; end
end

if [ "$enry_enabled" = 1 ] # enry enabled block BEGIN

# get most used programming language
function enry_get_language
    if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
        # don't compute language on huge repositories, use predefined key value pairs
        __enry_check_cached (prompt_pwd)

        if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
            set FISH_PROMPT_LAST_LANGUAGE (timeout --foreground 1 "/etc/fish/bin/enry" | head -1 | awk '{print $2}')
            if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
                set FISH_PROMPT_LAST_LANGUAGE "(to)"
            else
                set FISH_PROMPT_LAST_LANGUAGE_LENGTH (math (string length $FISH_PROMPT_LAST_LANGUAGE)+3)
            end
        end
    end
end

# print the detected language
function enry_print_language
    if [ "$FISH_PROMPT_LAST_LANGUAGE" != "" -a "$FISH_PROMPT_LAST_LANGUAGE" != "(to)" ]
       printf "["
       __print_language_colored "$FISH_PROMPT_LAST_LANGUAGE"
       printf "]─"
    end
end

# reset state on directory change
function enry_reset_state
    set FISH_PROMPT_LAST_LANGUAGE ""
    set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0
end

else # enry enabled block END

# stub functions when enry is disabled
function enry_get_language; end
function enry_print_language; end
function enry_reset_state; end

end
