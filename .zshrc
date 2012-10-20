# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="twilight"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Auto-update without prompting
DISABLE_UPDATE_PROMPT="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

source $ZSH/oh-my-zsh.sh

function tabname {
	printf "\e]1;$1\a"
}

export EDITOR="subl -w"
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
export AWS_RDS_HOME="/usr/local/Library/LinkedKegs/rds-command-line-tools/jars"

export LSCOLORS="exfxcxdxbxegedabagacad"

unsetopt sharehistory

# Zsh aliases
alias zshrc='subl ~/.zshrc'
alias reload='source ~/.zshrc'
alias rake='nocorrect rake'

# Git aliases
alias gp='git push'
alias gf='git fetch'
alias gd='git diff'
alias gr='git rebase'
alias gl='git pull --rebase'
alias gla='git pull --rebase --all'
alias gs='git status -s'
alias gss='git status'
alias gcm='git checkout master'
alias gcs='git checkout staging'
alias gb='git branch'
alias gbd='git branch -D'
alias gba='git branch -a'
alias gcb='git checkout -b'
alias gm='git merge'
alias gad='git add .'
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gam='git commit --amend'
alias gama='git commit -a --amend'
alias grh='git reset --hard'
alias gcp='git cherry-pick'
alias gmv='git mv'

# Other alises
alias stackup='rails s unicorn'
alias stackdebug='rails s --debug'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
