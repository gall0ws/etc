export PATH="/opt/homebrew/opt/node@14/bin:$PATH"

PS1='; '
PS2='	'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export PS1 PS2 WORDCHARS

alias ls='/bin/ls -G'
alias lc='/bin/ls -F'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

type thefuck >/dev/null && eval $(thefuck --alias)

PATH="/Users/gall0ws/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/gall0ws/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/gall0ws/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/gall0ws/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/gall0ws/perl5"; export PERL_MM_OPT;
