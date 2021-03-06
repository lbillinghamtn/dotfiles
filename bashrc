
# ssh agent (maybe only for git bash in windows)
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

# short ls aliasaes
alias la='ls -a --color'
alias lt='ls -lrt --color'
alias ls='ls --color'

# history showing datetime of command
alias histdate='HISTTIMEFORMAT="%Y-%m-%d %T " history'

# to get git working
if [ -d .git ]; 
then
    git config user.name "Laurence Billingham"
    # change this
    git config user.email "laurence.billingham@example.com"  
    git config color.ui "auto"
    git config core.editor "vim"
    git config help.autocorrect "5"
fi

# for python virtual environments
export WORKON_HOME=~/virtualenvs/
source virtualenvwrapper.sh

#   activate the relavent virtualenv when we cd into a project dir
PROMPT_COMMAND='prompt'

function prompt()
{
    if [ "$PWD" != "$MYOLDPWD" ]; then
        MYOLDPWD="$PWD"
        test -e .venv && workon `cat .venv`
    fi
}
