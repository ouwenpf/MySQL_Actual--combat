HISTSIZE=10000
#PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "
HISTTIMEFORMAT="%F %T $(whoami) "
HISTCONTROL="ignoreboth"
alias l='ls -AFhltr'
alias lh='l | head'
alias vi='vim'

GREP_OPTIONS="--color=auto"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='egrep --colour=auto'
alias  mysqlbinlog='mysqlbinlog  -vvv --base64-output=decode-rows'