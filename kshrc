## In order to load this: echo 'export ENV=$HOME/lib/kshrc' >> $HOME/.profile

[ -z "$PS1" ] && return

## options
set -o emacs
bind ^I=complete-list

## variables
PATH=.:$HOME/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/games
EDITOR=E
FCEDIT=$EDITOR
HOSTNAME=`hostname`
PAGER=less
MANPAGER=$PAGER
export EDITOR FCEDIT PATH PAGER MANPAGER
PS1='$ '
PS2=

## aliases
alias lc='lc -F'
alias unmount=umount
alias j='jobs -l'

## p9p environment
PLAN9=/opt/plan9
export PLAN9
PATH=$PATH:$PLAN9/bin

## go stuff
GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export GOPATH PATH

## machine specific options
case $HOSTNAME in
macao*)
	GOROOT=/usr/local/go
	PATH=$PATH:$GOROOT/bin

	ANDROID=/Users/gall0ws/Desktop/android-sdk-macosx/
	PATH=$PATH:${ANDROID}/tools:${ANDROID}/platform-tools

	PATH=/opt/local/bin:$PATH # macports
	export GOROOT PATH

	alias octave=/Applications/Octave.app/Contents/Resources/bin/octave
	;;

5620z)
	GOROOT=/usr/lib/go
	INFERNO=$HOME/inferno
	ANDROID=$HOME/android-sdk-linux
	PATH=$PATH:$GOROOT/bin:$INFERNO/Linux/386/bin:$ANDROID/tools
	export GOROOT
	
	for i in \
		dhclient\
		wpa_supplicant\
		wpa_cli\
		ifconfig\
		apt-get\
	; do
		alias $i="sudo $i"
	done
	
	↑() {
		setsid $@ >/dev/null 2>/tmp/arrow.log
	}
	
	;;
esac

## terminal specific options
case "$TERM" in
xterm)
	;;
	
rxvt*)
	TERM=linux
	;;

9term)
	## pagers are for sissies:
	export PAGER=cat
	export MANPAGER=nobs
	
	## misc:
	set +o emacs
	set +o vi
	PS1='⇛ '
	alias ⇛=
	alias ls='9 ls'
	alias bc='9 bc'
	alias wc='9 wc'
	;;

*)
	alias awd=	
	;;
esac

flash() {
	lsof +L1 \
		|awk '/Flash/ {
			sub(/.$/, "", $4); # trim access mode
			printf "/proc/%d/fd/%d\n", $2, $4
		}'
}

cd() {
	builtin cd "$@"
	awd
}

test "$USER" == "root"  && PS1='# '

export PATH

awd 
