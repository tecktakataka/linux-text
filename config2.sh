#!/bin/bash

# server-2

# GUI環境->メイン利用(GNOMEデスクトップ)
# Webブラウザとしての利用(FireFox)
# メールサーバーとしての利用(Postfix, Dovecot, Thunderbird)


# インストールするもの -> GNOME, FireFox, Postfix, Dovecot, Thunderbird

# postfix, Dovecot, Thunderbird, Firefoxをインストール
yum install -y postfix dovecot && \
# postfixを起動
systemctl start postfix.service && \
# postfixを有効化
systemctl enable postfix.service && \
# dovecotを起動
systemctl start dovecot.service && \
# dovecotを有効化
systemctl enable dovecot.service && \
# firewallにsmtpサービスを許可
firewall-cmd --permanent --add-service=smtp && \
# firewallにpop3サービスを許可
firewall-cmd --permanent --add-service=pop3 && \
# firewallにimapサービスを許可
firewall-cmd --permanent --add-port=143/tcp && \
# firewallをリロード
firewall-cmd --reload && \



# GNOMEデスクトップ環境用の設定
yum -y groupinstall "GNOME Desktop" && \
# ターゲットをGUIに設定
systemctl set-default graphical.target && \
# 日本語環境に設定
localectl set-locale LANG=ja_JP.UTF-8 && \
# firefoxをインストール
yum -y install firefox && \
# GUIの設定を反映させるためOSを再起動
reboot

echo 'setup is now complete!'