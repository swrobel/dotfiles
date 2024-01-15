1. `cd ~/`
1. `ln -sf Code/dotfiles/.* ~/` (ignore errors, files link fine)
1. `rm .git` (remove .git directory that may have been symlinked from here)
1. `Code/dotfiles/macos.sh`
1. Reboot
1. Install XCode
1. Install [Homebrew](https://brew.sh/) `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
1. `Code/dotfiles/brew.sh`
1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
1. Re-link .zshrc/.zprofile because they're overwritten by oh-my-zsh `ln -sf Code/dotfiles/.z* ~/`
1. `mackup restore`
1. Install [BetterTouchTool](https://bettertouchtool.net/releases/btt_2.428_recovery_mojave.zip)
1. Install [quartz filters](https://github.com/doekman/Apple-Quartz-Filters/releases)
