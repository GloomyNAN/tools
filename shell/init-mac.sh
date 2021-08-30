#!/bin/bash
# date:2021-08-30 10:14:09
# author:Gloomy
# description: init-mac.sh 

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Formulae

brew install emacs \
     ## Lang
     go python3 \

     ## Gun
     telnet tig tree htop wget bpytop \

     ## Others
     node docker git-lfs gh \

     ## package manager
     dep \
     # 命令提示工具
     tldr

# cask

brew install virtualbox visual-studio-code ngrok vagrant docker wkhtmktopdf keepassxc microsoft-edge


# uninstall
# brew tap beeftornado/rmtree
# brew rmtree git
# brew cleanup
# brew deps --tree --installed
# brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"

# bashrc

cat > ~/.bashrc << EOF

source ~/.profile

function git_branch {
 branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
 if [ "${branch}" != "" ];then
 if [ "${branch}" = "(no branch)" ];then
 branch="(`git rev-parse --short HEAD`...)"
 fi
 echo " ($branch)"
 fi
}

export PS1='\u@\h \[\033[01;36m\]\W\[\033[01;32m\]$(git_branch)\[\033[00m\] \$'

# Homestead
function homestead() {
( cd ~/WorkArea/GloomyNAN/Homestead && vagrant $* )
}

function killhomestead() {
 ps -ef|grep VirtualBox|awk '{print$2}'|xargs kill
}

function delbranch(){
( git push origin --delete $1 && git branch -d$1)
}

# Show Or Hide Hidden Files
function show() {
	defaults write com.apple.finder AppleShowAllFiles TRUE
	killall Finder
}

function hide() {
	 defaults write com.apple.finder AppleShowAllFiles FALSE
	 killall Finder
}

# React-Native
function rn() {
( react-native $* )
}

# alias
alias ll='ls -la'
alias ..="cd .."
alias ...="cd ../.."
alias h='cd ~'
alias c='clear'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'


## Git alias
alias pull='git pull origin'
alias merge='git merge'
alias fetch='git fetch'
alias rebase='git rebase'
alias push='git push origin'
alias add='git add -A'
alias gsub='git submodule'
alias gsubr='git submodule foreach git pull origin master --rebase'
alias gsubu='git submodule foreach git submodule update'
alias commit='git commit -m'
alias checkout='git checkout'
alias status='git status'
alias gpr='git pull --rebase'
alias tag='git tag'

## docker
alias dc='docker-compose'
alias do='docker'
EOF