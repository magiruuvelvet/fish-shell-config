##
## visit git repositories in the default web browser
##

# normalize git url to http
function __git_url_convert
    set -l url "$argv[1]"

    if [ (string length $url) = 0 ]
        return 1
    end

    if string_starts_with "$url" "http"
        echo "$url"
        return 0
    else
        # convert ssh url to http url
        set -l domain_start 1
        set -l domain_end 1

        # find domain
        set -l index 1
        for char in (echo "$url" | string split "")
            if [ "$char" = "@" ]
                set domain_start (math $index + 1)
            else if [ "$char" = ":" ]
                set domain_end $index
            end
            set index (math $index + 1)
        end

        set -l domain (string sub $url -s $domain_start -l (math $domain_end - $domain_start))

        # find path
        set -l remaining_url (string sub $url -s (math $domain_end + 1))

        # print url
        echo "https://$domain/$remaining_url"
        return 0
    end
end
