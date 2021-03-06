# default aliases

# unset this from bash/zsh when present
set -e PROMPT_COMMAND

if [ (uname) = "FreeBSD" ]
    alias ls='ls --color'
    alias ll='ls -lla'
else
    alias ls='ls -v --color'
    alias ll='ls -llav'
end

alias dir='dir --color'
alias vdir='vdir --color'

alias grep='grep --color'
alias fgrep='fgrep --color'
alias egrep='egrep --color'

# create and switch to directory in one go
function mkdircd
    mkdir -p $argv
    cd $argv
end
