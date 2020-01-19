function __string_column_width
    if [ -e /usr/local/lib/bashrc-tools/strcolumns ]
        /usr/local/lib/bashrc-tools/strcolumns "$argv[1]"
    else
        string length "$argv[1]"
    end
end
