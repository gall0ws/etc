## -*- sh -*-

[ -z "$PS1" ] && return
[ "$0" == "sh" ] && return

amiroot() {
    test `id -u` == 0
}

## options
set -o emacs
bind ^L=clear-screen

## locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL

## variables
PATH=.:$HOME/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/games
EDITOR='mg -n'
HOSTNAME=`hostname`
PAGER='less -r'
MANPAGER=$PAGER
XDG_CONFIG_HOME=~/etc/config

export PATH GOPATH EDITOR HOSTNAME PAGER MANPAGER XDG_CONFIG_HOME

test ! -z "$DISPLAY" && amiroot && {
	EDITOR=emacsclient
	export EDITOR
}

## prompt
PS1='% '
amiroot && PS1='# '
PS2='  '

# mouse friendly prompt:
%() {
    "$@"
}

netprompt() {
    PS1="${HOSTNAME}=; "
}

test ! -z "$SSH_CONNECTION" || test ! -z "$NETPROMPT" && netprompt

## aliases
alias j='jobs -l'
alias ls='ls -F'
alias mpv_mono='mpv --af=pan=1:[0.5,0.5]'
alias rxvt=urxvtc
alias unmount=umount
alias vi=nvi
alias xclip='xclip -selection clipboard'

## go stuff
GOPATH=~/go
PATH=$PATH:$GOPATH/bin
export GOPATH PATH

## npm stuff
NODE_PATH=~/opt/node_modules
export NODE_PATH

# functions
cd() {
    builtin cd "$@"
    awd
}

mon() {
      tail -F /var/log/messages
}

hist_on() {
    HISTFILE=~/.mksh_history
    export HISTFILE
}

hist_off() {
    unset HISTFILE
}

## terminal specific options
case "$TERM" in
    eterm-color)
	EDITOR=emacsclient
	export EDITOR
	alias awd=
	;;

    dumb)
	export PAGER=cat
	export MANPAGER=nobs
	set +o emacs
	set +o vi
	if [ ! -z "$EMACS" ]; then
	    alias awd=
	fi
	;;
esac

for i in ${HOSTNAME} local; do
    if [ -r ~/etc/kshrc.${i} ]; then
	. ~/etc/kshrc.${i}
    fi
done
