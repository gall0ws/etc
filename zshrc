## hey emacs, this is an -*-sh-*- file!

PS1='; '
PS2=' '
PATH=$HOME/bin:$PATH
MANPATH=$HOME/man:
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
EDITOR="emacsclient -nw"
ALTERNATE_EDITOR=""
LESS='-FMR --mouse'
XDG_CONFIG_HOME=$HOME/.config
export PS1 PS2 PATH MANPATH WORDCHARS EDITOR ALTERNATE_EDITOR LESS XDG_CONFIG_HOME

alias ls='lsd --date=relative --group-dirs=first --size=short --git'
alias la='ls -a'
alias lA='ls -A'
alias ll='ls -l'
alias lla='ll -a'
alias llA='ll -A'
alias lst='ls --tree'

alias bootout="sudo launchctl bootout user/`id -u`"
alias convert='magick'
alias dequarantine='xattr -r -d com.apple.quarantine'
alias diff='diff -u'
alias emacs='emacsclient -nw'
alias j='jobs'
alias pstree='pstree -g3 -w'
alias scrsaver='open /System/Library/CoreServices/ScreenSaverEngine.app'

if [ "$TERM_PROGRAM" = "iTerm.app"  -a -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
	source "${HOME}/.iterm2_shell_integration.zsh"
	export PS1=" "
fi

type thefuck >/dev/null && eval $(thefuck --alias)

PATH="/Users/gall0ws/perl5/bin${PATH:+:${PATH}}"
PERL5LIB="/Users/gall0ws/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
PERL_LOCAL_LIB_ROOT="/Users/gall0ws/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
PERL_MB_OPT="--install_base \"/Users/gall0ws/perl5\""
PERL_MM_OPT="INSTALL_BASE=/Users/gall0ws/perl5"
export PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT

PLAN9="$HOME/9"
PATH="$PATH:$PLAN9/bin"
export PLAN9 PATH

HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE HOMEBREW_NO_ENV_HINTS
