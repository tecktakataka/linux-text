#!/bin/bash

# server-4
# DNSキャッシュサーバー(secondary)としての利用(BIND)
# ファイルサーバーとしての利用(Samba)

# インストールするもの -> BIND, Samba

# bind関連とsambaをインストール
yum -y install bind bind-chroot bind-utils samba && \
# bind(chroot)を起動
systemctl start named-chroot.service && \
# bind(chroot)を有効化
systemctl enable named-chroot.service && \
# sambaを起動
systemctl start smb.service && \
# samba(名前解決機能)を起動
systemctl start nmb.service && \
# sambaを有効化
systemctl enable smb.service && \
# samba(名前解決機能)を有効化
systemctl enable nmb.service && \
# firewallにDNSサービスを許可
firewall-cmd --permanent --add-service=dns && \
# firewallにsambaを許可
firewall-cmd --permanent --add-service=samba && \
# firewallをリロード
firewall-cmd --reload && \
echo 'setup is now complete!'