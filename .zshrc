# https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
ulimit -n 20000

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="twilight"
ZSH_DISABLE_COMPFIX=true
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
plugins=(chruby)
source $ZSH/oh-my-zsh.sh
source ~/.zprofile
add-zsh-hook precmd chruby_auto

test -e "$HOME/.env_vars" && source $HOME/.env_vars

unsetopt sharehistory # Don't share history between terminal windows
unsetopt extendedglob # Disable extended pattern matching so # and other special chars don't get interpreted by ZSH
unsetopt autocd # Disable changing directories when typing the name of a directory without the preceding 'cd'
setopt nobanghist # Disable ZSH interpreting !
setopt histignorespace # Don't save commands prepended with space to history
disable r # Disable zsh builtin 'r' command that tells you the last command you entered

# Change name of terminal tab
tabname() {
  if [ ! -z "$1" ];then
    TABNAME=$1
  fi
  # Set to current directory if custom name hasn't been given
  local title=${TABNAME-${PWD##*/}}
  echo -ne "\e]1;$title\a"
}
add-zsh-hook precmd tabname

# Remove a directory from PATH
path_remove() {
  PATH=${PATH//":$1"/} # delete any instances in the middle or at the end
  PATH=${PATH//"$1:"/} # delete any instances at the beginning
}

# Add input to beginning of PATH unless it is already in it or it doesn't exist
path_prepend() {
  path_remove $1
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]];then
    PATH="$1:$PATH"
  fi
}

# If highlight is installed, always use colorful less command
if [ -x "$(command -v highlight)" ];then
  cless() { highlight -O ansi --force $@ | \less -R }
  alias less='cless'
else
  echo "Missing command highlight for syntax-highlighted less alias. Please brew install highlight."
fi

# Run less if passed a file, otherwise ls
ls_or_less() {
  local last_arg=$argv[$#argv]

  if [ -f "$last_arg" ];then
    # input is a file, send it to less to view
    less "$@"
  else
    # input, if any is passed to ls
    ls -G ${~@} # -G = colorized output
  fi
}

# Run cursor if available, otherwise code
cursor_or_code() {
  if [ -x "$(command -v cursor)" ];then
    cursor $@
  else
    code $@
  fi
}

# Show size of all subdirectories in current directory and sort by size descending
# du args: -h = human-readable, -d 1 = go one level deep
# gsort args: -h = human sort, -r = reverse sort so it's descending
dsize() {
  if [ -x "$(command -v gsort)" ];then
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
  heroku run $@ -- "rails console -- --simple-prompt"
}

rails_scaffold_without_views() {
  rails g scaffold $@ --skip-template-engine
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

# Use fzf to search history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

enable-dark-mode() {
  defaults write "${1}/Contents/Info.plist" NSRequiresAquaSystemAppearance false
}

disable-dark-mode() {
  defaults delete "${1}/Contents/Info.plist" NSRequiresAquaSystemAppearance
}

bundle_filtered() {
  bundle "$@" # | awk '!/^(Using|Fetching)/'
}

# https://gist.github.com/premek/6e70446cfc913d3c929d7cdbfe896fef
mv() {
  if [ "$#" -ne 1 ];then
    command mv "$@"
    return
  fi
  if [ ! -f "$1" ];then
    command file "$@"
    return
  fi

  read -ei "$1" newfilename
  mv -v "$1" "$newfilename"
}

# Repeat command until it exits with non-zero code
until_fail() {
  while :; do
    $@ || break
  done
}

brew_uninstall_and_autoremove() {
  brew uninstall "$@" && brew autoremove
}

git_pull_and_update() {
  local last_line=$(gl | tail -1)
  echo $last_line
  if [ $last_line != "Already up to date." ];then
    bin/update
  fi
}

# Git aliases
alias g='git'
alias gco='git checkout'
alias gp='git push'
alias gf='git fetch -p'
alias gd='git -p status -v -v'
alias gds='git diff HEAD --stat=150,80'
alias gdbo='git symbolic-ref refs/remotes/origin/HEAD --short'
alias gdb='gdbo | sed 's@^origin/@@''
alias gr='git rebase --autostash'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grb='git rebase $(gdb)'
alias gri='gr --interactive'
alias gl='git pull --rebase --prune --tags --autostash'
alias glu='git_pull_and_update'
alias gla='gl --all'
alias gs='git status -s'
alias gss='git status'
alias gcom='gco $(gdb) && gl'
alias gcomu='gco $(gdb) && glu'
alias gcomd='gcom && gmd && gp'
alias gcos='gco stage && gl'
alias gcod='gco develop && gl'
alias gcop='gco production && gl'
alias gcodm='gcod && gmm && gp'
alias gb='git branch'
alias gbd='git branch -D'
alias gba='git branch -a'
alias grp='git remote prune origin'
alias gbpm='git branch --merged $(gdb) | grep -v "\ $(gdb)" | xargs -n 1 git branch -d && grp'
alias gbpd='git branch --merged develop | grep -v "\ develop" | xargs -n 1 git branch -d && grp'
alias gbo='git branch --list --format "%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)"' # Local branches with no remote (orphans)
alias gbp='grp && for branch in `gbo`; do gbd "$branch"; done && gbpm' # Prune orphaned branches
alias gcb='git checkout -b'
alias gm='git merge --no-edit'
alias gmm='gm $(gdb)'
alias gmd='gm develop'
alias gmp='gm production'
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
alias gph='gp heroku main'
alias gpp='gp production production:main'
alias gppf='gpp --force-with-lease'
alias gps='gp staging main'
alias gpsf='gps --force-with-lease'
alias gpd='gp dokku'
alias gpdf='gpd --force-with-lease'
alias gpb='gpo && gpp'
alias gpbf='gpof && gppf'
alias gclean='g clean -df' # Remove all untracked files & directories
alias glogs='git log --no-merges --pretty="format:* %s" $(gdbo)..$(git branch --show-current)'
alias glog='git log --no-merges --pretty="format:%Cgreen%an%Creset %ar: %s" $(gdbo)..$(git branch --show-current)'
alias ggraph="g log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
alias gpt='gp --tags'
alias grad='g remote add'
alias gradd='grad'
alias grau='grad upstream'
alias grrm='g remote rm'
alias grv='g remote -v'
alias gauc='git update-index --skip-worktree'
alias gac='git update-index --no-skip-worktree'
alias gbsu='git branch -u origin/$(git branch --show-current)' # Set upstream to origin/current-branch

# github aliases
alias ghrc='gh repo clone'

# npm aliases
alias n='npm'
alias ni='npm i'
alias unpm= 'npm i -g --force npm'

# yarn aliases
alias y='yarn'
alias ya='y add'
alias yad='y add --dev'
alias yl='y lint'
alias yo='y outdated'
alias yrm='y remove'
alias yr='y run'
alias ys='y start'
alias yt='y test'
alias yu='y upgrade'
alias yui='y upgrade-interactive'

# Ruby aliases
alias rtest='ruby -Itest'
alias rake='nocorrect noglob rake'
alias ruby-install-cleanup='\ruby-install --cleanup'
alias ruby-install='ruby-install-no-rdoc'
alias ug='gem update --system && gem clean rubygems-update'
alias gi='gem install'
alias gu='gem uninstall'

# Bundler aliases
alias b='bundle_filtered install'
alias bu='bundle_filtered update'
alias be='bundle exec'
alias bc='bundle clean'
alias bo='bundle_filtered outdated'
alias ub='gem update bundler --default && gem clean bundler'
alias bur='bundle_filtered update --ruby'
alias by='b && y'
alias byu='bu && yu'
alias bub='bundle_filtered update --bundler'

# Rails aliases
alias rdbm='rake db:migrate:with_data || rake db:migrate'
alias rdbtm='RAILS_ENV=test rake db:migrate'
alias rdbc='rake db:create'
alias rdbd='rake db:environment:set db:drop'
alias rdbdc='rake db:environment:set db:drop db:create'
alias rdbs='rake db:seed'
alias rdbsu='rdbc && rdbsl && rdbs'
alias rdbsl='rake db:schema:load:with_data || rake db:schema:load'
alias rdbrb='rake db:rollback'
alias rdbdrb='rake data:rollback'
alias rdbrc='rdbd && rdbsu'
alias rdbrm='rake db:environment:set db:drop db:create db:migrate db:seed'
alias rdbrms='rdbrm && rdbs'
alias rdbtp='RAILS_ENV=test rake db:drop db:create db:schema:load'
alias update_migrations='rake railties:install:migrations && rdbm'
alias rg='rails g'
alias rd='rails d'
alias rgm='rg migration'
alias rgdm='rg data_migration'
alias rgs='rg scaffold'
alias rgsv='rails_scaffold_without_views'
alias rds='rd scaffold'
alias rc='rails c'
alias rs='rails s'
alias i='invoker'
alias is='i start'
alias ir='i reload'
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias pumalog='tail -f ~/Library/Logs/puma-dev.log'
alias pumakill='pkill -USR1 puma-dev'
alias rspec='nocorrect rspec'
alias rub='rake app:update:bin'
alias rpp='rake parallel:prepare'
alias rps='rake parallel:spec'
alias rpps='rpp && rps'
alias fs='foreman start -f Procfile.dev'

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
alias hrc='heroku autocomplete --refresh-cache'

# Rubocop aliases
alias cop='rubocop --parallel'
alias copa='rubocop --autocorrect-all'

# ls aliases
alias l='noglob ls_or_less'
alias ll='ls -lh' # -h = human-readable filesizes
alias la='ls -A' # -A = show dotfiles but not . & ..
alias lla='ls -lAh'

# rm aliases
alias rm='trash -F'
alias rmdir='trash -F'
alias realrm='\rm'

# Homebrew aliases
alias br='brew'
alias brclean='br cleanup'
alias bri='br install'
alias bru='brew_uninstall_and_autoremove'
alias brr='br reinstall --force'
alias bci='bri --cask'
alias bcu='bru --cask'
alias bcr='brr --cask'
alias brs='br search'
alias brinf='br info'
alias brl='br ls --versions | sort'
alias brh='br home'
alias bro='br outdated --verbose | sort'
alias brsr='br services restart'
alias brss='br services start'
alias brsp='br services stop'
alias brsl='br services list'
alias brdep='brew uses --installed'
alias brup='br upgrade && brclean'

# Other aliases
alias null='&> /dev/null'
alias e.="${EDITOR} ."
alias s="subl"
alias s.="s ."
alias sm="smerge"
alias sm.="sm ."
alias c="cursor_or_code"
alias c.="c ."
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'
alias st="stree"
alias st.="st ."
alias o="open"
alias o.="o ."
alias vup='vagrant up && vagrant ssh'
alias mkdir='mkdir -p' # Create all necessary directories in hierarchy
alias top='htop'
alias gateway='netstat -rn | grep default'
alias ping='prettyping'
alias gping='\ping -i 5 g.co'
alias rebuild_open_with='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
RUBY_PROCESS_NAMES='guard|invoker|bin/que|spring|rails|rspec|puma|chromedriver'
alias rgrep='ps -ww -o pid,%cpu,%mem,stat,command -p `pgrep -f $RUBY_PROCESS_NAMES` 2> /dev/null'
alias rkill='pgrep -f $RUBY_PROCESS_NAMES | xargs kill -9'
NODE_PROCESS_NAMES='webpack-dev-server|react-scripts'
alias ngrep='ps -ww -o pid,%cpu,%mem,stat,command -p `pgrep -f $NODE_PROCESS_NAMES` 2> /dev/null'
alias nkill='pgrep -f $NODE_PROCESS_NAMES | xargs kill -9'
alias help='tldr'
alias dui='ncdu'
alias flushdns='sudo killall -HUP mDNSResponder'
alias pgpid='realrm $HOMEBREW_PREFIX/var/postgres/postmaster.pid'
alias pgrestart='brew services restart postgresql'
alias it='itermocil'
alias finder_show_dotfiles='defaults write com.apple.finder AppleShowAllFiles true && killall Finder'
alias finder_hide_dotfiles='defaults write com.apple.finder AppleShowAllFiles false && killall Finder'
alias curl-redirect='curl -Ls -w %{url_effective} -o /dev/null'
alias curl-json='curl -H "accept: application/json"'
alias youtube-dl='yt-dlp -f "bv+ba/b"'

# Zsh aliases
alias zshrc="s ~/.zshrc"
alias zprofile="s ~/.zprofile"
alias reload='source ~/.zshrc'
alias r!='reload'
alias tab='tabname'

# Docker aliases
alias drmc='docker rm $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'
alias drmall='drmc && drmi'

# Python aliases
alias pipr='pip install -r requirements.txt -r dev-requirements.txt -r test-requirements.txt'
alias pipu='pipr --upgrade'
alias upip='pip install --upgrade pip'

# Django aliases
alias mp='./manage.py'
alias mprs='mp runserver_plus'
alias mpm='mp migrate'
alias mpmk='mp makemigrations'
alias mps='mp shell_plus'
alias mpt='mp test --keepdb'
alias mpsd='mp seed'
alias mpst='mp startapp'
alias cw='(cd project/ && celery -A celery_worker worker -l info)'

# CocoaPods aliases
alias pi='cd ios; be pod install --repo-update; cd ..'
alias pu='cd ios; be pod update --repo-update; cd ..'

# Fastlane aliases
alias fl='be fastlane'
alias flb='BABEL_ENV=staging fl beta'
alias flr='fl release'

# If gnu ln is installed, always use it with --relative option so we don't have to provide full path to the source
if [ -x "$(command -v gln)" ];then
  alias ln='gln -s --relative'
else
  echo "Missing command gln for relative-path ln alias. Please brew install coreutils."
fi

ruby-install-no-rdoc() {
  ruby-install-cleanup $@ -- --disable-install-rdoc
}

if [[ $TERM_PROGRAM == "iTerm.app" ]];then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

compctl -g '~/.itermocil/*(:t:r)' itermocil

# Automatically activate virtualenv if available
VIRTUAL_ENV_DISABLE_PROMPT=1
virtualenv_auto() {
  if [[ -f venv/bin/activate ]];then
    source venv/bin/activate
  fi
}

add-zsh-hook precmd virtualenv_auto

prepend_bin() {
  path_prepend ./bin
  zstyle -e ':completion:*' command-path 'reply=( "$PWD/bin" "$path[@]" )'
}

add-zsh-hook precmd prepend_bin

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
