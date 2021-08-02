#!/bin/bash

# server-3
# DNS キャッシュサーバー(primary)としての利用(BIND)

# インストールするもの -> BIND



# bind関連をインストール
yum -y install bind bind-chroot bind-utils　&& \
# bind(chroot)を起動
systemctl start named-chroot.service && \
# bind(chroot)を有効化
systemctl enable named-chroot.service && \
# firewallにDNSサービスを許可
firewall-cmd --permanent --add-service=dns && \
# firewallをリロード
firewall-cmd --reload && \
echo 'setup is now complete!'