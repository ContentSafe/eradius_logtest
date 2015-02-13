# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias pi='ping 8.8.8.8'
    alias up="nmcli con up id 'Beeline 3G modem'"
    alias down="nmcli con down id 'Beeline 3G modem'"

    alias do='docker'
    alias ll='ls -lth --color=auto'
    alias l='ls -lth --color=auto'
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias S='cd /home/vtarasen/soft/'
    alias D='cd /home/vtarasen/dev/'
    alias M5='cd /srv/data/~proj/moderator5'
    alias R='cd /home/vtarasen/dev/_RUNWAY/'
    alias A='cd /home/vtarasen/dev/_API/'
    alias X='cd /home/vtarasen/dev/_XRAY/'
    alias T='cd /home/vtarasen/dev/_TPOSS/'
    alias M='cd /home/vtarasen/dev/_MASTER/'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    alias ga='git add'
    alias gd='git diff'
    alias gb='git branch'
    alias gbd='git branch -D'
    alias gl='git log --decorate=full'
    alias glp='git log --decorate=full -p'
    alias gcl='git clone'
    alias gch='git checkout'
    alias gchm='git checkout master'
    alias gpl='git pull'
    alias gph='git push'
    alias gcm='git commit'
    alias gs='git status'
    alias gst='git stash'
    alias gstd='git stash drop'
    alias gt='git tag'
    alias grm='git rm'
    alias grt='git remote -v'

    alias tb='tetrapak build'
    alias td='tetrapak deps'
    alias ts='tetrapak start'
    alias tsh='tetrapak shell'
    alias tc='tetrapak clean'
    alias tt='tetrapak test'
    alias tcb='tetrapak clean build'
    alias tchx='tetrapak check:xref'

    alias pc='pcmanfm &'

    alias 16='sudo /home/vtarasen/soft/r16.sh'
    alias 17='sudo /home/vtarasen/soft/r17.sh'    
fi


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

export ERL_LIBS="$HOME/soft"

#export PATH="$PATH:/srv/otp/r16b03/bin/:/home/vtarasen/soft"
#export PATH="$PATH:/srv/otp/17.0-rc1/bin/"
