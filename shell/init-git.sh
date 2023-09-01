#!/bin/bash
# date:2023-09-01 15:43:06
# author:Gloomy
# description: init-git.sh 

## git相关设置

cat >> ~/.gitconfig << EOF
[user]
	name = GloomyNAN
	email = gloomynan@gmail.com
[includeIf "gitdir:~/WorkArea/demo/"]
    path = .gitconfig-demo
[pull]
	rebase = true
[core]
	excludesfile = ~/.gitignore_global
[commit]
	template = ~/.gitmessage.txt
EOF

cat >> ~/.gitignore_global << EOF
*~
.*.swp
.DS_Store
EOF

cat >> ~/.gitconfig-demo << EOF
[user]
  name = demo
  email = demo@demo.com
EOF

cat >> ~/.gitmessage.txt << EOF
# commit log 请遵造以下格式，并注意冒号后面有一个空格
# 
# <type>: <subject> {必要}
# 
# <body> {非必要}
# 
# <footer> {非必要}
# 
# 范例
# feat: implementation login api function
#
# finished login module and integration with server login api
#
# Closes OR-xxxx 
# 
# <Type>
# 请遵守下列标签
# feat: 新功能
# fix: Bug修复
# docs: 文档改变
# style: 代码格式改变
# refactor: 功能重构
# perf: 性能优化
# test: 增加测试代码
# build: 改变build工具
# ci: 与ci相关的设定
# add: 增加一些跟功能无关的档案
# 3rd: 增加第三方
# 
# <Subject>
# 用来简要描述影响本次变动，概述即可
# 
# <Body>
# 具体的修改讯息，越详细越好
# 
# <Footer>
# 如果是要关闭特定 Issue 或 Bug. 可以使用 Closes PROJECT-1 or Resolves PROJECT-1 or Fixes PROJECT-1 
# 具体清参考 https://docs.gitlab.com/ee/user/project/integrations/jira.html
#
EOF