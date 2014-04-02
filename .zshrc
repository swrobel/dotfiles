ZSH=$HOME/.oh-my-zsh
ZSH_THEME="twilight"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git terminalapp)
source $ZSH/oh-my-zsh.sh

tabname() {
  printf "\e]1;$1\a"
}

cless() {
  pygmentize $1 > /dev/null 2>&1
  if [ $? -eq 0 ];then
    pygmentize -f terminal256 -O style=native $1 | /usr/bin/less -R
  else
    /usr/bin/less $1
  fi
}

dsize() { du -h -d 1 "$*" 2> /dev/null | gsort -h ; }

export EDITOR="subl -w"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
# Twilight theme
export LSCOLORS="exfxcxdxbxegedabagacad"
# Set JAVA_HOME if java is installed
/usr/libexec/java_home > /dev/null 2>&1
if [ $? -eq 0 ];then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

unsetopt sharehistory # Don't share history between terminal windows
unsetopt extendedglob # Disable extended pattern matching so # and other special chars don't get interpreted by ZSH
setopt nobanghist # Disable ZSH interpreting !

# Zsh aliases
alias zshrc='subl ~/.zshrc'
alias reload='source ~/.zshrc'
alias rake='nocorrect noglob rake'
alias rspec='nocorrect rspec'
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
alias gad='git add -A .'
alias ga='git add -A'
alias gc='git commit'
alias gca='git commit -a'
alias gam='git commit --amend'
alias gama='git commit -a --amend'
alias grh='git reset --hard'
alias gcp='git cherry-pick'
alias gmv='git mv'
alias grm='git rm'
alias gsp='git stash pop'
alias gst='git stash -u'
alias gcl='git clone'
alias gph='gp heroku master'
alias gpb='gp && gph'
alias gpf='gp -f'
alias gpbf='gpf && gph -f'
alias gpp='gp prod master'
alias gppf='gpp -f'
alias gclean='g clean -df' # Remove all untracked files & directories
alias glog="g log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"

# Rails aliases
alias update_migrations='be rake railties:install:migrations && be rake db:migrate'
alias rtest='ruby -Itest'
alias devlog='tail -f log/development.log'
alias rdbm='be rake db:migrate'
# Below from http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/
alias b='bundle'
alias be='b exec'
alias bi="b install --path vendor" # Install gems to vendor/ruby
alias bil="b install --local" # Install gems from vendor/cache
alias bu="b update"
alias bp="b package" # Cache downloaded but not-yet-installed gems in vendor/cache
alias binit="bi && bp && echo 'vendor/ruby' >> .gitignore"

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
alias vup='vagrant up && vagrant ssh'

PATH=/usr/local/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin
DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# If pygments is installed, always use colorful less command
command -v pygmentize > /dev/null 2>&1
if [ $? -eq 0 ];then
  alias less='cless'
fi

# chruby 'after use' hook to prioritize ./bin before chruby-supplied rubygem bin paths
# https://github.com/postmodern/chruby/wiki/Implementing-an-'after-use'-hook

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

save_function()
{
  local ORIG_FUNC="$(declare -f $1)"
  local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
  eval "$NEWNAME_FUNC"
}

save_function chruby old_chruby

chruby() {
  old_chruby $*
  PATH=./bin:$PATH
}

chruby ruby-2.1
