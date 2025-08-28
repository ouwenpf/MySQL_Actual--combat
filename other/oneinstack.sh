HISTSIZE=10000
#PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]\\$ "
HISTTIMEFORMAT="%F %T $(whoami) "
HISTCONTROL="ignoreboth"
alias ll='ls -Fhltr'
alias lh='l | head'
alias vi='vim'

GREP_OPTIONS="--color=auto"
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='egrep --colour=auto'
alias  mysqlbinlog='mysqlbinlog  -vvv --base64-output=decode-rows'
alias  ps='ps -eo user,pid,lstart,etime,%cpu,%mem,cmd'
PS1='[\[\e[31m\]\u@\[\e[36m\]\h \w\[\e[37m\]]\[\e[33m\]\$\[\e[m\] '