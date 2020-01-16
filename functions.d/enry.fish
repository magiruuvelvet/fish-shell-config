##
## Enry
##

# contains the enry_check_cached function
source /etc/fish/private/enry_config.fish

set FISH_PROMPT_LAST_LANGUAGE ""
set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0

# get most used programming language
function enry_get_language
    if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
        # don't compute language on huge repositories, use predefined key value pairs
        enry_check_cached (prompt_pwd)

        if [ "$FISH_PROMPT_LAST_LANGUAGE" = "" ]
            set FISH_PROMPT_LAST_LANGUAGE (timeout --foreground 1 "/etc/fish/bin//enry" | head -1 | awk '{print $2}')
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
       print_language_colored "$FISH_PROMPT_LAST_LANGUAGE"
       printf "]─"
    end
end

# reset state on directory change
function enry_reset_state
    set FISH_PROMPT_LAST_LANGUAGE ""
    set FISH_PROMPT_LAST_LANGUAGE_LENGTH 0
end
