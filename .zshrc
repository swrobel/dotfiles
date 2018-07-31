ZSH=$HOME/.oh-my-zsh
ZSH_THEME="twilight"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
typeset +gx -A GITHUB
GITHUB[user]=swrobel
GH_BASE_DIR=$HOME/Code
GH_FETCH_REPOS="true"
plugins=(terminalapp chruby gh)
source $ZSH/oh-my-zsh.sh

# Change name of terminal tab
tabname() {
  printf "\e]1;$1\a"
}

# Remove a directory from PATH
path_remove() {
  PATH=${PATH/":$1"/} # delete any instances in the middle or at the end
  PATH=${PATH/"$1:"/} # delete any instances at the beginning
}

# Add input to beginning of PATH unless it is already in it or it doesn't exist
path_add() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

# Colorized less output
cless() {
  highlight -O ansi $1 > /dev/null 2>&1
  if [ $? -eq 0 ];then
    highlight -O ansi -c stdout $1 | /usr/bin/less -R
  else
    /usr/bin/less $*
  fi
}

# If pygments is installed, always use colorful less command
command -v highlight > /dev/null 2>&1
if [ $? -eq 0 ];then
  alias less='cless'
else
  echo "Missing command highlight for syntax-highlighted less alias. Please brew install highlight."
fi

# Run less if passed a file, otherwise ls
ls_or_less() {
  local last_arg=$argv[$#argv]

  if [ -f "$last_arg" ]; then
    # input is a file, send it to less to view
    less "$@"
  else
    # input, if any is passed to ls
    ls -G "$@" # -G = colorized output
  fi
}

# Show size of all subdirectories in current directory and sort by size descending
# du args: -h = human-readable, -d 1 = go one level deep
# gsort args: -h = human sort, -r = reverse sort so it's descending
dsize() {
  command -v gsort > /dev/null 2>&1
  if [ $? -eq 0 ];then
    du -h -d 1 "$@" 2> /dev/null | gsort -hr
  else
    echo "Missing command gsort. Please brew install coreutils."
  fi
}

# Run a webserver in the current directory
serve() {
  port="${1:-8000}"
  ruby -run -e httpd . -p $port
}

heroku_migrate() {
  heroku rake db:migrate $@
  heroku restart $@
}

heroku_console() {
  heroku run $@ -- rails console -- --simple-prompt
}

# Add reload command which runs unload then load
launchctl() {
  if [ $1 = "reload" ];then
    /bin/launchctl unload ${@:2}
    /bin/launchctl load ${@:2}
  else
    /bin/launchctl $@
  fi
}

# Run atom-beta if installed, otherwise atom
atom_or_beta() {
  atom-beta -v > /dev/null 2>&1
  if [ $? -eq 0 ];then
    atom-beta $@
  else
    atom $@
  fi
}

# ENV vars
export EDITOR="subl -w"
export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
# Twilight theme
export LSCOLORS="exfxcxdxbxegedabagacad"
# Set JAVA_HOME if java is installed
/usr/libexec/java_home > /dev/null 2>&1
if [ $? -eq 0 ];then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi
export GOPATH=~/.go
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export PYTHON_PATH=~/Library/Python/3.5
export ANDROID_HOME=/usr/local/opt/android-sdk
export RUBY_CONFIGURE_OPTS=--disable-install-doc
export NODE_ENV=development
source $HOME/.env_vars

unsetopt sharehistory # Don't share history between terminal windows
unsetopt extendedglob # Disable extended pattern matching so # and other special chars don't get interpreted by ZSH
setopt nobanghist # Disable ZSH interpreting !
disable r # Disable zsh builtin 'r' command that tells you the last command you entered

# Git aliases
alias g='git'
alias gco='git checkout'
alias gp='git push'
alias gf='git fetch'
alias gd='git -p status -v -v'
alias gds='git diff HEAD --stat=150,80'
alias gr='git rebase'
alias grc='gr --continue'
alias gra='gr --abort'
alias gri='gr --interactive'
alias gl='git pull --rebase'
alias gla='git pull --rebase --all'
alias gs='git status -s'
alias gss='git status'
alias gcom='gco master && gl'
alias gcomd='gcom && gmd && gp'
alias gcos='gco staging && gl'
alias gcod='gco dev && gl'
alias gcodm='gcod && gmm && gp'
alias gb='git branch'
alias gbd='git branch -D'
alias gba='git branch -a'
alias grp='git remote prune origin'
alias gbp='git branch --merged master | grep -v "\ master" | xargs -n 1 git branch -d && grp'
alias gbpd='git branch --merged dev | grep -v "\ master" | grep -v "\ dev" | xargs -n 1 git branch -d && grp'
alias gcb='git checkout -b'
alias gm='git merge --no-edit'
alias gmm='gm master'
alias gmd='gm dev'
alias gmt='git mergetool'
alias gma='git merge --abort'
alias gad='git add -A .'
alias ga='git add -A'
alias gc='git commit'
alias gcm='gc -m'
alias gca='gc -a'
alias gcam='gca -m'
alias gam='gc --amend'
alias gamnt='gam --no-edit'
alias gama='gc -a --amend'
alias gamant='gama --no-edit'
alias grh='git reset --hard'
alias gcp='git cherry-pick'
alias gcpa='gcp --abort'
alias gcpc='gcp --continue'
alias gmv='git mv'
alias grm='git rm'
alias gsp='git stash pop'
alias gst='git stash -u --keep-index'
alias gcl='git clone'
alias gpo='gp -u origin'
alias gpf='gp --force-with-lease'
alias gpof='gpf -u origin'
alias gph='gp heroku master'
alias gpp='gp production master'
alias gppf='gpp --force-with-lease'
alias gps='gp staging'
alias gpsf='gps --force-with-lease'
alias gpb='gpo && gpp'
alias gpbf='gpof && gppf'
alias gclean='g clean -df' # Remove all untracked files & directories
alias glog="g log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias gpt='gp --tags'
alias grad='g remote add'
alias gradd='grad'
alias grau='grad upstream'
alias grrm='g remote rm'
alias grv='g remote -v'
alias gauc='git update-index --assume-unchanged'
alias gac='git update-index --no-assume-unchanged'
alias gbsu='git branch -u origin/$(git name-rev --name-only HEAD)' # Set upstream to origin/current-branch

# yarn aliases
alias y='yarn'
alias ya='y add'
alias yad='y add --dev'
alias yl='y lint'
alias yo='y outdated'
alias yrm='y remove'
alias yr='y run'
alias yu='y upgrade'
alias yui='y upgrade-interactive'
alias yt='y test'

# Ruby aliases
alias rtest='ruby -Itest'
alias rake='nocorrect noglob rake'
alias ruby-install-cleanup='\ruby-install --cleanup'
alias ruby-install='ruby-install-no-rdoc'
alias ug='gem update --system'
alias gi='gem install'
alias gu='gem uninstall'

# Bundler aliases
alias b='bundle'
alias be='b exec'
alias bc='b clean'
alias bo='b outdated'
alias ub='gem update bundler && gem clean bundler'
alias bu='b update'
alias bur='bu --ruby'
alias by='b && y'

# Rails aliases
alias rdbm='rake db:migrate'
alias rdbtm='RAILS_ENV=test rake db:migrate'
alias rdbs='rake db:seed'
alias rdbsl='rake db:schema:load_if_ruby db:structure:load_if_sql'
alias rdbrb='rake db:rollback'
alias rdbrc='rake db:environment:set db:drop db:setup'
alias rdbrm='rake db:environment:set db:drop db:create db:migrate'
alias rdbrms='rdbrm && rdbs'
alias rdbtp='RAILS_ENV=test rake db:environment:set db:drop db:schema:load_if_ruby db:structure:load_if_sql'
alias update_migrations='rake railties:install:migrations && rdbm'
alias rg='rails g'
alias rgm='rg migration'
alias rc='rails c'
alias i='invoker'
alias is='invoker start'
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias pumalog='tail -f ~/Library/Logs/puma-dev.log'
alias pumakill='pkill -USR1 puma-dev'
alias rspec='nocorrect rspec'
alias rub='rake app:update:bin'
alias rpp='rake parallel:prepare'
alias rps='rake parallel:spec'
alias rpps='rpp && rps'

# Heroku aliases
alias h='heroku'
alias hc='heroku_console'
alias hl='h logs -t'
alias hr='h restart'
alias hm='heroku_migrate'
alias hcp='hc -r production'
alias hcs='hc -r staging'
alias hlp='hl -r production'
alias hls='hl -r staging'
alias hrp='hr -r production'
alias hrs='hr -r staging'
alias hmp='hm -r production'
alias hms='hm -r staging'
alias hrun='h run'
alias hrunp='hrun -r production'
alias hruns='hrun -r staging'
alias hcf='h config'
alias hcfp='hcf -r production'
alias hcfs='hcf -r staging'
alias hh='h help'

# Rubocop aliases
alias cop='rubocop --parallel'
alias copa='rubocop --auto-correct'

# ls aliases
alias l='ls_or_less'
alias ll='ls -lh' # -h = human-readable filesizes
alias la='ls -A' # -A = show dotfiles but not . & ..
alias lla='ls -lAh'

# rm aliases
alias rm='trash -F'
alias rmdir='trash -F'
alias realrm='\rm'
alias sudo='sudo '

# Homebrew aliases
alias br='brew'
alias brclean='br cleanup && br cask cleanup'
alias brup='br upgrade && brclean'
alias bri='br install'
alias bru='br uninstall'
alias bci='br cask install'
alias bcu='br cask uninstall'
alias bcr='br cask reinstall --force'
alias brs='br search'
alias brinf='br info'
alias bcinf='br cask info'
alias bcl='br cask ls --versions'
alias brl='{ br ls --versions ; bcl } | sort'
alias brh='br home'
alias bch='br cask home'
alias bro='br outdated'

# Other aliases
alias which='type -p'
alias null='&> /dev/null'
alias e.="${EDITOR} ."
alias s="subl"
alias s.="s ."
alias a="atom_or_beta"
alias a.="a ."
alias st="stree"
alias st.="st ."
alias o="open"
alias o.="o ."
alias vup='vagrant up && vagrant ssh'
alias mkdir='mkdir -p' # Create all necessary directories in hierarchy
alias top='top -o cpu'
alias gateway='netstat -rn | grep default'
alias gping='ping -i 5 g.co'
alias rebuild_open_with='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
RUBY_PROCESS_NAMES='guard|spring|ruby|rails|rspec|puma|chromedriver'
alias rgrep='ps -o pid,%cpu,%mem,stat,command -p `pgrep -f $RUBY_PROCESS_NAMES` 2> /dev/null'
alias rkill='pgrep -f $RUBY_PROCESS_NAMES | xargs kill -9'
NODE_PROCESS_NAMES='webpack-dev-server'
alias ngrep='ps -o pid,%cpu,%mem,stat,command -p `pgrep -f $NODE_PROCESS_NAMES` 2> /dev/null'
alias nkill='pgrep -f $NODE_PROCESS_NAMES | xargs kill -9'

# Zsh aliases
alias zshrc="s ~/.zshrc"
alias reload='source ~/.zshrc'
alias r!='reload'

# If gnu ln is installed, always use it with --relative option so we don't have to provide full path to the source
command -v gln > /dev/null 2>&1
if [ $? -eq 0 ];then
  alias ln='gln -s --relative'
else
  echo "Missing command gln for relative-path ln alias. Please brew install coreutils."
fi

PATH=$HOME/.yarn/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin:$GOPATH/bin:$PYTHON_PATH/bin
DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# chruby 'after use' hook to prioritize ./bin before chruby-supplied rubygem bin paths
# https://github.com/postmodern/chruby/wiki/Implementing-an-'after-use'-hook

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# Latest ruby version directory is always unversioned
if [ -d "/usr/local/Cellar/ruby/" ];then
  RUBIES+=(/usr/local/Cellar/ruby/*)
fi

# For older ruby versions that are put in directories like "ruby@2.3"
unsetopt nomatch # Disable warning if there are no matches for the glob below
for dir in /usr/local/Cellar/ruby@[.0-9]*
do
  if [ -d $dir ];then
    RUBIES+=($dir/*)
  fi
done
setopt nomatch

if [ -d "/usr/local/Cellar/rubinius/" ];then
  RUBIES+=(/usr/local/Cellar/rubinius/*)
fi

if [ -d "/usr/local/Cellar/jruby/" ];then
  RUBIES+=(/usr/local/Cellar/jruby/*)
fi

# Get chruby to run before the prompt prints
# https://github.com/postmodern/chruby/issues/191#issuecomment-64091397
if [[ $PS1 ]]; then
  precmd_functions+=("chruby_auto")
  preexec_functions=${preexec_functions:#"chruby_auto"}
fi

save_function() {
  local ORIG_FUNC="$(declare -f $1)"
  local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
  eval "$NEWNAME_FUNC"
}

save_function chruby old_chruby

chruby() {
  # Run chruby and let it do its path manipulation
  old_chruby $@
  # Make sure ./bin is first in PATH
  path_remove ./bin
  path_add ./bin
}

ruby-install-no-rdoc() {
  ruby-install-cleanup $@ -- --disable-install-rdoc
}
