#!/bin/bash

# server-1

# Webサーバーとしての利用(Apache)
# ↑のDNS権威サーバーとしての利用(BIND)


# インストールするもの -> Apache, BIND

# bind関連とApacheをインストール
yum -y install bind bind-chroot bind-utils httpd && \
# bind(chroot)を起動
systemctl start named-chroot.service && \
# bind(chroot)を有効化
systemctl enable named-chroot.service && \
# Apacheを起動
systemctl start httpd.service && \
# Apacheを有効化
systemctl enable httpd.service && \
# firewallにDNSサービスを許可
firewall-cmd --permanent --add-service=dns && \
# firewallにHTTPサービスを許可
firewall-cmd --permanent --add-service=http && \
# firewallをリロード
firewall-cmd --reload && \
echo 'setup is now complete!'