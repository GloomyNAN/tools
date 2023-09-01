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

brew install \
    ## Lang
    go@1.16 python3 node@14 \

    ## Gun
    telnet tig tree htop wget bpytop curl mysql-client lazygit pssh \

    ## Others
    git-lfs git-flow lazygit gh ncdu emacs pandoc ffmpeg mycli iredis pgcli tmux tldr osx-cpu-temp \

    ## docer
    lazydocker docker docker-compose \

    # java
    maven

    # react-native
    cocoapods watchman gradle android-platform-tools \

    # emacs
    ## dirvish
    coreutils fd poppler ffmpegthumbnailer mediainfo imagemagick
     
# cask
brew install visual-studio-code android-studio arduino sourcetree visual-studio \      
    
    # 研发
    docker google-chrome iterm2 shadowsocksx-ng-r clashx tunnelblick \
    
    ## 必备应用
    wpsoffice  baidunetdisk qq wechat wechatwork feishu tor-browser \
    
    ##  小工具
    snip cheatsheet skim recordit ngrok keepassxc drawio postman kap go2shell fluid \
    
    ## ide
    intellij-idea phpstorm goland webstorm rider \

    ## k8s
    lens kubernetes-cli \
    
    ## dev-tools
    oss-browser calibre snipaste \

    # java
    zulu8 zulu11 zulu17
    --cask

# npm
npm config set registry https://registry.npm.taobao.org
npm install -g yarn

# emacs

## web-beautify
npm -g install js-beautify

## lsp server
npm i -g typescript-language-server
npm i -g typescript
npm i -g vscode-html-languageserver-bin
npm i -g intelephense
npm i -g docsify-cli

### markdown
npm i -g unified-language-server

### vue2
npm install -g vls
## vue3
npm install -g @volar/vue-language-server

### YAML
npm install -g yaml-language-server

### DockerFile
npm install -g dockerfile-language-server-nodejs

### html
npm install react-native-rename -g

yarn config set registry https://registry.npm.taobao.org/

### css
npm install -g vscode-langservers-extracted

### JS/TS
npm i -g javascript-typescript-langserver

### fly-check
npm i -g eslint
npm install -g csslint

# uninstall
# brew tap beeftornado/rmtree
# brew rmtree git
# brew cleanup
# brew deps --tree --installed
# brew leaves | xargs brew deps --installed --for-each | sed "s/^.*:/$(tput setaf 4)&$(tput sgr0)/"

# pip

## lsp

### nginx
pip3 install -U nginx-language-server

# bashrc

cat >> ~/.bashrc << EOF

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

# Alias

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
alias gsc='git sparse-checkout'

alias lzg='lazygit'
alias lzd='lazydocker'

# docker shortcut commands
function dab(){
  docker exec -it $* /bin/bash	
}

function das(){
  docker exec -it $* /bin/sh
}

alias dkc='docker compose'
alias dk='docker'

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

./init-git.sh

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
# 禁止.DS_Store生成
# defaults write com.apple.finder AppleShowAllFiles FALSE;killall Finder

# 恢复.DS_Store生成
# defaults write com.apple.finder AppleShowAllFiles TRUE
# defaults delete com.apple.desktopservices DSDontWriteNetworkStores

# 删除之前生成的.DS_Store
# sudo find / -name ".DS_Store" -depth -exec rm {} \;