#!/bin/bash
# date:2021-08-30 10:14:09
# author:Gloomy
# description: init-mac.sh 

# .emacs.d
# mac System Preferences -> Security & Privacy -> Privacy" full disk /usr/bin/ruby
git clone git@github.com:GloomyNAN/emacs.d.git ~/.emacs.d/

# install Homebrew

## 从本镜像下载安装脚本并安装 Homebrew / Linuxbrew

git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

## 也可从 GitHub 获取官方安装脚本安装 Homebrew / Linuxbrew
/bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"

# 更换清华大学源

git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
git -C "$(brew --repo homebrew/cask-versions)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-versions.git
git -C "$(brew --repo homebrew/command-not-found)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-command-not-found.git

brew update-reset

# Formulae

brew install \
     ## Lang
     go@1.16 python3 \

     ## Gun
     telnet tig tree htop wget bpytop \

     ## Others
     node@14 git-lfs gh ncdu \

     # 命令提示工具
     tldr osx-cpu-temp \

     # java
     maven

# cask
brew install emacs  visual-studio-code android-studio arduino sourcetree \
     # 研发
     virtualbox vagrant docker microsoft-edge google-chrome  iterm2 shadowsocksx-ng-r tunnelblick \ 
     ## 必备应用
     wpsoffice  baidunetdisk qq wechat wechatwork \
     ##  小工具
     cheatsheet skim recordit ngrok wkhtmktopdf keepassxc drawio \
     --cask

# uninstall
# brew tap beeftornado/rmtree
# brew rmtree git
# brew cleanup
# brew deps --tree --installed
# brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"

# bashrc

cat > ~/.bashrc << EOF

source ~/.profile

## perl
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

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

# openjdk
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# go

## 配置 GOPROXY 环境变量
export PATH="/opt/homebrew/opt/go@1.16/bin:$PATH"
export GOROOT="$(go env GOROOT)"
export GOPROXY=https://goproxy.io,direct
## 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
export GOPRIVATE=git.mycompany.com,github.com/my/private
export GOPATH="$HOME/.govendor"
EOF
