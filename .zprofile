# Homebrew
if [ "$(arch)" = "arm64" ]; then
  export HOMEBREW_PREFIX=/opt/homebrew
else
  export HOMEBREW_PREFIX=/usr/local
fi

# If set, do not print any hints about changing Homebrew’s behaviour with environment variables.
export HOMEBREW_NO_ENV_HINTS=1

# If set, do not check for broken linkage of dependents or outdated dependents after installing, upgrading or reinstalling formulae. This will result in fewer dependents (and their dependencies) being upgraded or reinstalled but may result in more breakage from running brew install formula or brew upgrade formula.
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# If set, Homebrew will download in parallel using this many concurrent connections. Setting to auto will use twice the number of available CPU cores (what our benchmarks showed to produce the best performance). If set to 1 (the default), Homebrew will download in serial.
export HOMEBREW_DOWNLOAD_CONCURRENCY=auto

# Twilight theme
export LSCOLORS="exfxcxdxbxegedabagacad"

# Other env vars
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GOPATH=~/.go
export ANDROID_HOME=$HOME/Library/Android/sdk
export RUBY_CONFIGURE_OPTS=--disable-install-doc
export THOR_MERGE=ksdiff
export CLOUDSDK_PYTHON_SITEPACKAGES=1
export EDITOR="subl -w"
export npm_config_yes=true

PATH=$HOME/.yarn/bin:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$HOMEBREW_PREFIX/mysql/bin:$HOMEBREW_PREFIX/share/npm/bin:$HOMEBREW_PREFIX/opt/python/libexec/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.bin:$GOPATH/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
DYLD_LIBRARY_PATH=$HOMEBREW_PREFIX/mysql/lib:$DYLD_LIBRARY_PATH

if [[ -f $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh ]]; then
  source $HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh
fi

source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh

# Latest ruby version directory is always unversioned
if [ -d "$HOMEBREW_PREFIX/Cellar/ruby/" ];then
  RUBIES+=($HOMEBREW_PREFIX/Cellar/ruby/*)
fi

# For older ruby versions that are put in directories like "ruby@2.3"
unsetopt nomatch # Disable warning if there are no matches for the glob below
for dir in $HOMEBREW_PREFIX/Cellar/ruby@[.0-9]*
do
  if [ -d $dir ];then
    RUBIES+=($dir/*)
  fi
done
setopt nomatch

if [ -d "$HOMEBREW_PREFIX/Cellar/rubinius/" ];then
  RUBIES+=($HOMEBREW_PREFIX/Cellar/rubinius/*)
fi

if [ -d "$HOMEBREW_PREFIX/Cellar/jruby/" ];then
  RUBIES+=($HOMEBREW_PREFIX/Cellar/jruby/*)
fi

if [ -d "$HOME/.asdf/installs/ruby/" ];then
  RUBIES+=($HOME/.asdf/installs/ruby/*)
fi

source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh
