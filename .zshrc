ZSH=$HOME/.oh-my-zsh
ZSH_THEME="twilight"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(git terminalapp chruby)
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

# Colorized less output
cless() {
  highlight -O ansi $1 > /dev/null 2>&1
  if [ $? -eq 0 ];then
    highlight -O ansi -c stdout $1 | /usr/bin/less -R
  else
    /usr/bin/less $*
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

# ENV vars
export EDITOR="subl"
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
source $HOME/.env_vars

unsetopt sharehistory # Don't share history between terminal windows
unsetopt extendedglob # Disable extended pattern matching so # and other special chars don't get interpreted by ZSH
setopt nobanghist # Disable ZSH interpreting !

# Zsh aliases
alias zshrc="${EDITOR} ~/.zshrc"
alias reload='source ~/.zshrc'

# Git aliases
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
alias gcpa='gcp --abort'
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
alias gpt='gp --tags'
alias grad='g remote add'
alias grrm='g remote rm'

# Ruby/Rails aliases
alias rtest='ruby -Itest'
alias devlog='tail -f log/development.log'
alias rake='nocorrect noglob rake'
alias rdbm='rake db:migrate'
alias update_migrations='rake railties:install:migrations && rdbm'
alias rspec='nocorrect rspec'
alias gem='GEM_HOME=$GEM_ROOT gem' # Install gems to ~/.rubies instead of ~/.gem
alias ruby-install-cleanup='ruby-install --cleanup'
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
alias hc='h run console'
alias hl='h logs -t'
alias hr='h restart'
alias hm='h rake db:migrate && hr'

# ls aliases
alias l='ls_or_less'
alias ll='l -lh' # -h = human-readable filesizes
alias la='l -A' # -A = show dotfiles but not . & ..
alias lla='l -lAh'

# Other aliases
alias which='type -p'
alias mou='open -a Mou'
alias e.="${EDITOR} ."
alias s.="subl ."
alias a.="atom ."
alias outin='cd .. && popd'
alias vup='vagrant up && vagrant ssh'
alias mkdir='mkdir -p' # Create all necessary directories in hierarchy

# If pygments is installed, always use colorful less command
command -v highlight > /dev/null 2>&1
if [ $? -eq 0 ];then
  alias less='cless'
else
  echo "Missing command highlight for syntax-highlighted less alias. Please brew install highlight."
fi

# If gnu ln is installed, always use it with --relative option so we don't have to provide full path to the source
command -v gln > /dev/null 2>&1
if [ $? -eq 0 ];then
  alias ln='gln -s --relative'
else
  echo "Missing command gln for relative-path ln alias. Please brew install coreutils."
fi

PATH=/usr/local/bin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin:$GOPATH/bin
DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

# chruby 'after use' hook to prioritize ./bin before chruby-supplied rubygem bin paths
# https://github.com/postmodern/chruby/wiki/Implementing-an-'after-use'-hook

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# Get chruby to run before the prompt prints
# https://github.com/postmodern/chruby/issues/191#issuecomment-64091397
if [[ $PS1 ]]; then
  precmd_functions+=("chruby_auto")
  preexec_functions=${preexec_functions:#"chruby_auto"}
fi

save_function()
{
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
