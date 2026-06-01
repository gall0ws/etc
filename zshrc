## hey emacs, this is an -*-sh-*- file!

setopt AUTO_MENU
setopt NO_LIST_BEEP
setopt NO_NOMATCH
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt IGNORE_EOF
setopt LIST_TYPES

PATH=$(/bin/cat <<END | /usr/bin/tr '\n' :
.
$HOME/bin
$HOME/go/bin
$HOME/.local/bin
/opt/homebrew/bin
/opt/homebrew/sbin
/usr/local/bin
/usr/bin
/bin
/usr/local/sbin
/usr/sbin
/sbin
/Library/Apple/usr/bin
/System/Cryptexes/App/usr/bin
END
)
export PATH=${PATH%?}

PS1='; '
PS2='  '
MANPATH=$HOME/man:$HOME/.local/share/man:       # trailing ':' is not a typo.
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
EDITOR='emacsclient -nw'
ALTERNATE_EDITOR=''
LESS='-FMRX -x4 --use-color --mouse'
XDG_CONFIG_HOME=$HOME/.config
export PS1 PS2 MANPATH WORDCHARS EDITOR ALTERNATE_EDITOR LESS XDG_CONFIG_HOME

if [ $USER = root ]; then
    export PS1='# '
fi

if [ -x $HOME/bin/lesspipe ]; then
    export LESSOPEN='|lesspipe %s'
fi

if [ "$TERM_PROGRAM" = "iTerm.app" ] && [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

type lsd >/dev/null && {
    alias ls='lsd --config-file=$HOME/etc/lsd.yaml'
    alias lst='ls --tree'
}
alias la='ls -a'
alias lA='ls -A'
alias ll='ls -l'
alias lla='ll -a'
alias llA='ll -A'

alias bootout="sudo launchctl bootout user/`id -u`"
alias convert='magick'
alias dequarantine='xattr -r -d com.apple.quarantine'
alias diff='diff -u'
alias Emacs='/opt/homebrew/bin/emacs -nw'
alias emacs='emacsclient -nw'
alias j='jobs'
alias ldd='otool -L'
alias ping='ping -i.5 -a'
alias pstree='ps -axo user,pid,ppid,pgid,start,command | pstree -wg3 -f-'
alias scrsaver='open /System/Library/CoreServices/ScreenSaverEngine.app'
alias watch='watch -pt -n1'

if [ "$TERM" = "dumb" ]; then
    PAGER=more
    MANPAGER=$PAGER
    EDITOR=ed
    export PAGER MANPAGER EDITOR
fi

type thefuck >/dev/null && eval $(thefuck --alias)

PATH="$PATH:${HOME}/perl5/bin"
PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
PERL_MB_OPT="--install_base \"${HOME}/perl5\""
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
export PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT

PYTHON_VERSION=3.9
PATH="${PATH}:${HOME}/Library/Python/${PYTHON_VERSION}/bin"
export PATH

PLAN9="$HOME/9"
PATH="$PATH:$PLAN9/bin"
export PLAN9 PATH

HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_NO_ENV_HINTS=1
HOMEBREW_EVAL_ALL=1
export HOMEBREW_NO_AUTO_UPDATE HOMEBREW_NO_ENV_HINTS HOMEBREW_EVAL_ALL

MTR_OPTIONS='-i 0.5 -y 2 -o SRDLBAWV'
export MTR_OPTIONS

# Returns true (false) when dark mode is enabled (disabled)
function darkmode () {
    defaults read -g AppleInterfaceStyle >/dev/null 2>&1
}

function ccat () {
    mode=$(if darkmode; then echo dark; else echo light; fi)
    /opt/homebrew/bin/ccat --bg=$mode --color=always $@
}
