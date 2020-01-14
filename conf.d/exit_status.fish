function map_exit_status_to_signal_name
    set -l exit_status "$argv[1]"

    switch $exit_status
        case 126; echo EXEC
        case 127; echo CNF
        case 128; echo EXIT
        case 129; echo SIGHUP
        case 130; echo SIGINT
        case 131; echo SIGQUIT
        case 132; echo SIGILL
        case 133; echo SIGTRAP
        case 134; echo SIGABRT
        case 135; echo SIGBUS
        case 136; echo SIGFPE
        case 137; echo SIGKILL
        case 138; echo SIGUSR1
        case 139; echo SIGSEGV
        case 140; echo SIGUSR2
        case 141; echo SIGPIPE
        case 142; echo SIGALRM
        case 143; echo SIGTERM
        case 144; echo SIGSTKFLT
        case 145; echo SIGCHLD
        case 146; echo SIGCONT
        case 147; echo SIGSTOP
        case 148; echo SIGTSTP
        case 149; echo SIGTTIN
        case 150; echo SIGTTOU
        case 151; echo SIGURG
        case 152; echo SIGXCPU
        case 153; echo SIGXFSZ
        case 154; echo SIGVTALRM
        case 155; echo SIGPROF
        case 156; echo SIGWINCH
        case 157; echo SIGIO
        case 158; echo SIGPWR
        case \*; echo $exit_status
    end
end
