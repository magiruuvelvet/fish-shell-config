source /etc/fish/conf.d/config.fish

function su
    command su --shell=/bin/fish $argv
end
