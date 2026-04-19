PS1='%F{150}> %f'
PS2=' '
PATH=$HOME/bin:$PATH
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
EDITOR=mg
LESS='-FMR --mouse'
XDG_CONFIG_HOME=$HOME/.config
export PS1 PS2 PATH WORDCHARS EDITOR LESS XDG_CONFIG_HOME

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
	export PS1=" "
fi

alias ls='lsd --date=relative --group-dirs=first --size=short --git'
alias la='ls -a'
alias lA='ls -A'
alias ll='ls -l'
alias lla='ll -a'
alias llA='ll -A'
alias lst='ls --tree'

alias diff='diff -u'
alias scrsaver="open /System/Library/CoreServices/ScreenSaverEngine.app"
alias bootout="sudo launchctl bootout user/`id -u`"
alias convert="magick"
alias dequarantine='xattr -r -d com.apple.quarantine'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

type thefuck >/dev/null && eval $(thefuck --alias)

PATH="/Users/gall0ws/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/gall0ws/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/gall0ws/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/gall0ws/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/gall0ws/perl5"; export PERL_MM_OPT;

PLAN9="$HOME/src/plan9port"
PATH="$PATH:$PLAN9/bin"
export PLAN9 PATH

export PATH="/opt/homebrew/opt/node@14/bin:$PATH"
