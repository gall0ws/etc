export PATH="/opt/homebrew/opt/node@14/bin:$PATH"

PS1='; '
PS2='	'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
EDITOR=mg

export PS1 PS2 WORDCHARS EDITOR

alias ls='ls -G'
alias scrsaver="open /System/Library/CoreServices/ScreenSaverEngine.app"
alias bootout="sudo launchctl bootout user/`id -u`"

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
