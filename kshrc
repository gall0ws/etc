[ -z "$PS1" ] && return
[ "$0" == "sh" ] && return

## options
set -o emacs
bind ^L=clear-screen

## locale
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL

## variables
PATH=.:$HOME/bin:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/games
GOPATH=~/go
EDITOR=mg
FCEDIT=$EDITOR
HOSTNAME=`hostname`
PAGER=less
MANPAGER=$PAGER
export PATH GOPATH EDITOR FCEDIT HOSTNAME PAGER MANPAGER

PS1='% '
PS2=

# mouse friendly prompt:
%() {
	"$@"
}

# root prompt:
test "$(id -u)"x == "0"x  && PS1='# '

## aliases
alias ls='/bin/ls -F -c1'
alias lc='/bin/ls -F'
alias unmount=umount
alias j='jobs -l'
alias vi=nvi
alias rxvt=urxvtc
alias emacs="emacsclient -t -a=''"

## p9p environment
PLAN9=/usr/local/plan9
export PLAN9
PATH=$PATH:$PLAN9/bin

## ccache
test x"$(id -u)" == x"0" && {
	PATH=/usr/local/libexec/ccache:$PATH
	CCACHE_PATH=/usr/bin:/usr/local/bin
	CCACHE_DIR=/var/ccache
	export PATH CCACHE_PATH CCACHE_DIR
}

## go stuff
GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin
export GOPATH PATH

## npm stuff
NPM_CONFIG_PREFIX=~/npm-g
PATH=$PATH:$NPM_CONFIG_PREFIX/bin

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

5620z.local)
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

banana2.local)
	if [ "`uname`" == "FreeBSD" ]; then
	
		for i in \
			zzz\
			freq\
			shutdown\
		; do
		alias $i="sudo $i"
	done
	
		cdports() {
			  test ! -z "$1" && __dir=$1
			  cd /usr/ports/${__dir}
		}
		rdsysctl() {
			/sbin/sysctl $1 | cut -d: -f2-
		}
		temp() {
			n=$1
			test -z "$n" && n=0
			rdsysctl hw.acpi.thermal.tz$n.temperature
		}
	fi
esac

## terminal specific options
case "$TERM" in
dumb)
	if [ "$termprog" == "9term" ] || [ "$termprog" == "win" ]; then
		## pagers are for sissies:
		export PAGER=cat
		export MANPAGER=nobs
	
		## misc:
		set +o emacs
		set +o vi
	fi
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

mon() {
      tail -F /var/log/messages /var/log/.${DISPLAY:-0.log}
}
export PATH

awd 
