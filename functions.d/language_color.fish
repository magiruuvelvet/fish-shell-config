##
## print a programming language in a specific color
## colors were taken from GitHub
##

function print_language_colored
    if [ "$argv[1]" = "C++" ]
        set_color --bold f34b7d
    else if [ "$argv[1]" = "C" ]
        set_color --bold 555555
    else if [ "$argv[1]" = "CMake" ]
        set_color --bold cccccc
    else if [ "$argv[1]" = "JavaScript" -o "$argv[1]" = "NodeJS" ]
        set_color --bold cabb4b # -> f1e05a (not readable on light background)
    else if [ "$argv[1]" = "TypeScript" ]
        set_color --bold 2b7489
    else if [ "$argv[1]" = "Ruby" -o "$argv[1]" = "RubyGems" -o "$argv[1]" = "Rake" ]
        set_color --bold 701516
    else if [ "$argv[1]" = "Shell" ]
        set_color --bold 89e051
    else if [ "$argv[1]" = "fish" ]
        set_color --bold 89e051
    else if [ "$argv[1]" = "Roff" ]
        set_color --bold ecdebe
    else if [ "$argv[1]" = "Lua" ]
        set_color --bold 000080
    else if [ "$argv[1]" = "Java" ]
        set_color --bold b07219
    else if [ "$argv[1]" = "Switf" ]
        set_color --bold ffac45
    else if [ "$argv[1]" = "PHP" ]
        set_color --bold 4f5d95
    else if [ "$argv[1]" = "CSS" ]
        set_color --bold 563d7c
    else if [ "$argv[1]" = "Rust" -o "$argv[1]" = "Cargo" ]
        set_color --bold dea584
    else if [ "$argv[1]" = "Rust" ]
        set_color --bold f18e33
    else if [ "$argv[1]" = "Go" ]
        set_color --bold 00add8
    else if [ "$argv[1]" = "Python" ]
        set_color --bold 3572a5
    else if [ "$argv[1]" = "Makefile" ]
        set_color --bold 427819
    else if [ "$argv[1]" = "LLVM" ]
        set_color --bold 185619
    else if [ "$argv[1]" = "HTML" ]
        set_color --bold e34c26
    else if [ "$argv[1]" = "Gentoo" ]
        set_color --bold 4e4371
    else if [ "$argv[1]" = "(to)" ]
        set_color --italics e7e7e7
    end

    printf "$argv[1]"
    set_color normal
end
