#!/bin/bash
# date:2021-08-30 10:14:09
# author:Gloomy
# description: init-mac.sh 

chsh -s /bin/bash

# .emacs.d
# mac System Preferences -> Security & Privacy -> Privacy" full disk /usr/bin/ruby
git clone git@github.com:GloomyNAN/emacs.d.git ~/.emacs.d/

# install Homebrew
## 从本镜像下载安装脚本并安装 Homebrew / Linuxbrew
git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh
rm -rf brew-install

test -r ~/.bash_profile && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile

## 也可从 GitHub 获取官方安装脚本安装 Homebrew / Linuxbrew
# /bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"

# 更换清华大学源
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
brew update

# maven
cp ./preferences/settings ~/.m2/

# Formulae

brew install shivammathur/php/php@7.2

brew install \
     ## Lang
     go@1.16 python3 php@7.2\

     ## Gun
     telnet tig tree htop wget bpytop curl mysql-client \

     ## Others
     node@14 git-lfs git-flow gh ncdu emacs pandoc \

     ## docer
     lazydocker boot2docker docker docker-compose docker-machine \

     # 命令提示工具
     tldr osx-cpu-temp \

     # java
     maven openjdk@11

     # react-native
     cocoapods watchman gradle android-platform-tools

# cask
brew install visual-studio-code android-studio arduino sourcetree \
     # 研发
     docker microsoft-edge google-chrome  iterm2 shadowsocksx-ng-r tunnelblick \ 
     ## 必备应用
     wpsoffice  baidunetdisk qq wechat wechatwork feishu tor-browser \
     ##  小工具
     snip cheatsheet skim recordit ngrok keepassxc drawio postman kap go2shell \
     ## k8s
     lens kubernetes-cli \
     ## dev-tools
     oss-browser calibre
     --cask

# npm

npm config set registry https://registry.npm.taobao.org
npm install -g yarn

## lsp server

npm i -g typescript-language-server
npm i -g typescript
npm i -g vscode-html-languageserver-bin
npm i -g intelephense
npm i -g docsify-cli 
npm i -g eslint

yarn config set registry https://registry.npm.taobao.org/

## react native
npm install react-native-rename -g
# uninstall
# brew tap beeftornado/rmtree
# brew rmtree git
# brew cleanup
# brew deps --tree --installed
# brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"

# git

cat > ~/.gitignore_global <<EOF

*~
.DS_Store

EOF

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

# http&https proxy

function ssoff(){
                unset http_proxy
                unset https_proxy
                echo -e "已关闭代理"
}

function sson() {
                export http_proxy="http://127.0.0.1:1087"
                export https_proxy=$http_proxy
                echo -e "已开启代理"
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

## env
alias dnginx='docker exec -it nginx /bin/sh'
alias dphp72='docker exec -it php /bin/sh'
alias dphp56='docker exec -it php56 /bin/sh'
alias dphp54='docker exec -it php54 /bin/sh'
alias dmysql57='docker exec -it mysql57 /bin/bash'
alias dredis='docker exec -it redis /bin/sh'

# homebrew
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

# openjdk
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# php
export PATH="/opt/homebrew/opt/php@7.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.2/sbin:$PATH"

# node
export PATH="/usr/local/opt/node@14/bin:$PATH"

# mysql-cli
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# go

## 配置 GOPROXY 环境变量
export PATH="/usr/local/opt/go@1.16/bin:$PATH"
export GOROOT="$(go env GOROOT)"
export GOPROXY=https://goproxy.io,direct
## 还可以设置不走 proxy 的私有仓库或组，多个用逗号相隔（可选）
export GOPRIVATE=git.mycompany.com,github.com/my/private
export GOPATH="$HOME/.govendor"

# android

export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# etc
export PATH="/usr/local/sbin:$PATH"

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

EOF


```bash
# ide File Header
/**
 * @PROJECT  ${PROJECT_NAME}
 * @PACKAGE  ${PACKAGE_NAME}
 * @Description
 * @create: ${DATE} ${TIME}
 * @Author ${USER} <GloomyNAN@gmail.com>
 * @Copyright ${YEAR} ${USER}
 * @Link https://github.com/GloomyNAN
 * @Link http://gloomynan.com
 * @Version 1.0
 */

# 简化版

/**
 * @Description 
 * @create: ${DATE} ${TIME}
 * @Author ${USER} <GloomyNAN@gmail.com>
 * @Version 1.0
*/
```
