#!/bin/bash

# 全台共通設定

# yumをアップデート
#yum -y update && \
# firewallを起動
systemctl start firewalld.service && \
# firewallを有効化
systemctl enable firewalld.service && \
# 便利ツールをインストール
yum -y install tree tmux && \
# init.shが終わったことを知らせる
echo 'init.sh is done!'