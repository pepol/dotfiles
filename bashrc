#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

txtblk='\e[0;30m' # Black - Regular  
txtred='\e[0;31m' # Red  
txtgrn='\e[0;32m' # Green  
txtylw='\e[0;33m' # Yellow  
txtblu='\e[0;34m' # Blue  
txtpur='\e[0;35m' # Purple  
txtcyn='\e[0;36m' # Cyan  
txtwht='\e[0;37m' # White  
bldblk='\e[1;30m' # Black - Bold  
bldred='\e[1;31m' # Red  
bldgrn='\e[1;32m' # Green  
bldylw='\e[1;33m' # Yellow  
bldblu='\e[1;34m' # Blue  
bldpur='\e[1;35m' # Purple  
bldcyn='\e[1;36m' # Cyan  
bldwht='\e[1;37m' # White  
unkblk='\e[4;30m' # Black - Underline  
undred='\e[4;31m' # Red  
undgrn='\e[4;32m' # Green  
undylw='\e[4;33m' # Yellow  
undblu='\e[4;34m' # Blue  
undpur='\e[4;35m' # Purple  
undcyn='\e[4;36m' # Cyan  
undwht='\e[4;37m' # White  
bakblk='\e[40m'   # Black - Background  
bakred='\e[41m'   # Red  
bakgrn='\e[42m'   # Green  
bakylw='\e[43m'   # Yellow  
bakblu='\e[44m'   # Blue  
bakpur='\e[45m'   # Purple  
bakcyn='\e[46m'   # Cyan  
bakwht='\e[47m'   # White  
txtrst='\e[0m'    # Text Reset  

export EDITOR=vim
export BROWSER="chromium"
export ANT_HOME=/usr/share/apache-ant
export PATH=~pepol/src/other/v/debug/src/cmd:~pepol/src/other/v/debug/src/script:~pepol/bin:/opt/erlware/bin:$PATH
export GOPATH=~pepol/src/go
export SENDMAIL="/usr/bin/sendmail -t %<"

pre_prompt () {
    printf "\n $txtred%s@%s: $bldgrn%s $txtpur%s\n$txtrst" "$USER" "$HOSTNAME" "$PWD" "$(~pepol/bin/vcprompt)"
}

PROMPT_COMMAND=pre_prompt
PS1='[\j]-> '

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize
shopt -s globstar

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

[[ -f /etc/profile.d/erlware.sh ]] && . /etc/profile.d/erlware.sh

PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

# . /usr/lib/python3.4/site-packages/powerline/bindings/bash/powerline.sh
