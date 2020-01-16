## show last downloaded file
function fish_prompt_xdg_download_info
    # get latest modified file
    set -l last_download (string trim (ls --color=always -t | head -1))
    # filter ANSI escape sequences
    set -l last_download_filtered (echo "$last_download" | string replace -ra '\e\[[^m]*m' '')
    # calculate length of filtered text
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (/usr/local/lib/bashrc-tools/strcolumns "$last_download_filtered")
    set FISH_PROMPT_EXTRAS_TOTAL_LENGTH (math $FISH_PROMPT_EXTRAS_TOTAL_LENGTH+18)

    # print unfiltered text with escape sequences to keep the MIME type formatting
    printf "│ "
    set_color cccccc
    printf "最新のファイル:"
    set_color normal
    printf " $last_download"
end