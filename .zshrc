# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="twilight"

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
plugins=(git osx terminalapp)

source $ZSH/oh-my-zsh.sh

function tabname {
	printf "\e]1;$1\a"
}

export EDITOR="subl -w"
export JAVA_HOME="$(/usr/libexec/java_home)"
#export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
#export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
#export AWS_RDS_HOME="/usr/local/Library/LinkedKegs/rds-command-line-tools/jars"
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

export LSCOLORS="exfxcxdxbxegedabagacad"

unsetopt sharehistory # Don't share history between terminal windows
unsetopt extendedglob # Disable extended pattern matching so # and other special chars don't get interpreted by ZSH
setopt nobanghist # Disable ZSH interpreting !

# Zsh aliases
alias zshrc='subl ~/.zshrc'
alias reload='source ~/.zshrc && rvm reload > /dev/null'
alias rake='nocorrect rake'
alias which='type -p'

# Git aliases
alias gco='git checkout'
alias gp='git push'
alias gf='git fetch'
alias gd='git diff HEAD'
alias gds='git diff HEAD --stat=150,80'
alias gr='git rebase'
alias grc='gr --continue'
alias gra='gr --abort'
alias gri='gr --interactive'
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
alias gmt='git mergetool'
alias gma='git merge --abort'
alias gad='git add .'
alias ga='git add'
alias gc='git commit'
alias gca='git commit -a'
alias gam='git commit --amend'
alias gama='git commit -a --amend'
alias grh='git reset --hard'
alias gcp='git cherry-pick'
alias gmv='git mv'
alias grm='git rm'
alias gsp='git stash pop'
alias gst='git stash'
alias gcl='git clone'
alias gph='gp heroku master'
alias gpb='gp && gph'
alias gpf='gp -f'
alias gpbf='gpf && gph -f'
alias gpp='gp prod master'
alias gppf='gpp -f'

# Rails aliases
alias be='bundle exec'
alias update_migrations='be rake railties:install:migrations && be rake db:migrate'
alias test='ruby -Itest'
alias devlog='tail -f log/development.log'

# Heroku aliases
alias h='heroku'
alias hc='h console'
alias hl='h logs -t'
alias hr='h restart'
alias hm='h rake db:migrate && hr'

# Other aliases
alias mou='open -a Mou'
alias s.='subl .'
alias lla='ll -A'
alias outin='cd .. && popd'
alias rvmrc='rvm rvmrc to ruby-version'

PATH=/usr/local/sbin:/usr/local/bin:/usr/local/heroku/bin:/Applications/Postgres.app/Contents/MacOS/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH:$HOME/.rvm/bin:~/.bin
DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH
export rvmsudo_secure_path=1
