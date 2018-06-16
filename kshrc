## -*- sh -*-
[ -z "$PS1" ] && return
[ "$0" == "sh" ] && return

amiroot() {
    test `id -u` == 0
}

## options
HISTCONTROL='ignoredups:ignorespace'
HISTFILE=$HOME/.ksh_history
set -o emacs
bind -m ^L="^U^K clear^M^Y"

## locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL

## variables
EDITOR=vi
BLOCKSIZE=K
HOSTNAME=`hostname`
PAGER='less -rX'
MANPAGER=$PAGER
XDG_CONFIG_HOME=~/etc/config

export GOPATH EDITOR BLOCKSIZE HOSTNAME PAGER MANPAGER XDG_CONFIG_HOME

## prompt
PS1='$ '
amiroot && PS1='# '
PS2='  '

netprompt() {
    PS1="`hostname -s`$ "
}

test ! -z "$SSH_CONNECTION" || test ! -z "$NETPROMPT" && netprompt

## aliases
alias j='jobs -l'
alias linen='awk '\''{printf "%d %s\n", NR, $0}'\'''
alias mess='tail -f /var/log/messages'
alias mpv_mono='mpv --af=pan=1:[0.5,0.5]'
alias tac='linen | sort -rn | sed "s/^[0-9]* //g"'
alias unmount=umount

alias xclip='xclip -selection clipboard'

## go stuff
GOPATH=~/go
PATH=$PATH:$GOPATH/bin
export GOPATH PATH

## npm stuff
NODE_PATH=~/lib/node_modules
export NODE_PATH

## terminal specific options
case "$TERM" in
    dumb)
	export PAGER=cat
	export MANPAGER=nobs
	set +o emacs
	set +o vi
	if [ ! -z "$EMACS" ]; then
	    awd() { }
	fi
	;;
esac

for i in ${HOSTNAME} local; do
    if [ -r ~/etc/kshrc.${i} ]; then
	. ~/etc/kshrc.${i}
    fi
done
