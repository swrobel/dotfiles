1. `cd ~/`
1. `ln -sf Code/dotfiles/.* ~/` (ignore errors, files link fine)
1. `Code/dotfiles/macos.sh`
1. Reboot
1. Install XCode
1. Install [Homebrew](https://brew.sh/) `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
1. `Code/dotfiles/brew.sh`
1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
1. Re-link .zshrc because it's overwritten by oh-my-zsh `ln -sf Code/dotfiles/.zshrc ~/`
1. Copy [quartz filters](https://github.com/joshcarr/Apple-Quartz-Filters) to `/Library/PDF Services`
