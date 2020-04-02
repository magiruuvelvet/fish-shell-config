##
## detect build system by looking for specific files
##

function __detect_build_system

    if [ -f "CMakeLists.txt" ]; echo "CMake"
    # todo: *.pro -> QMake
    else if [ -f "wscript" ]; echo "Waf"
    else if [ -f "meson.build" ]; echo "Meson"

    else if [ -f "build.gradle" ]; echo "Gradle"
    else if [ -f "pom.xml" ]; echo "Maven"

    else if [ -f "Cargo.toml" ]; echo "Cargo"

    else if [ -f "requirements.txt" -o -f "setup.py" ]; echo "Python"

    else if [ -f "Gemfile" ]; echo "RubyGems"
    else if [ -f "Rakefile" ]; echo "Rake"

    else if [ -f "composer.json" ]; echo "Composer"

    else if [ -d "node_modules" -o -f "package.json" ]; echo "NodeJS"

    # keep this at the last position
    else if [ -f "Makefile" -o -f "makefile" -o -f "configure" -o -f "autogen.sh" ]
        echo "Makefile"

    end
end

function __print_build_system
    if [ (string length "$argv[1]") != 0 ]
        printf "["
        __print_language_colored "$argv[1]"
        printf "]─"
    end
end
