# yum -y update && \
# プロビジョニング用シェルスクリプトを定義
script = <<SCRIPT
yum -y install bind bind-chroot bind-utils && \
yum -y install httpd mod_ssl mailx dovecot && \
yum -y install  vim tree tmux && \
systemctl start named-chroot.service && \
systemctl enable named-chroot.service && \
systemctl start dovecot.service && \
systemctl enable dovecot.service && \
systemctl start firewalld.service && \
systemctl start httpd.service && \
systemctl enable httpd.service && \
systemctl enable firewalld.service && \
firewall-cmd --permanent --add-service=dns && \
firewall-cmd --permanent --add-service=http && \
firewall-cmd --permanent --add-service=smtp && \
firewall-cmd --permanent --add-service=pop3 && \
firewall-cmd --permanent --add-port=143/tcp && \
firewall-cmd --reload && \
sed -i s/SELINUX=enforcing/SELINUX=disabled/ /etc/selinux/config  && \
reboot && \
echo 'setup is now complete!'
SCRIPT


# 個別の設定を定義
user = "taka"
class_number = "13"

Vagrant.configure("2") do |config|
  # boxに利用するゲストOSを定義(全ゲストOS共通)
  config.vm.box = "centos/7"

  # each文を利用して、サーバーを4台作成
  (1..4).each do |i|
    # ブロック変数内で利用するローカル変数を定義
    # server変数に1~4を代入
    server = "server-#{i}"
    # hostname変数に1~4を代入
    hostname = "#{user}-#{i}"
    # ip_address変数に"192.168.99.176~179"を代入
    ip_address = "192.168.19.#{class_number.to_i * 4 + 124 + (i.to_i - 1)}"

    config.vm.define "#{server}" do |server|
      # ホスト名を設定
      server.vm.hostname = "#{hostname}"
      # (デフォルトのNATに加えて、)ブリッジネットワークを設定
      # IPアドレスを設定 / ネットワークの自動起動を設定(デフォルトでもON)
      server.vm.network :public_network, ip: "#{ip_address}", auto_config: true

      server.vm.provider :virtualbox do |v|
        # VirtualBoxのメモリを1536MBに設定
        v.memory = "1536"
        # ヘッドレス起動に設定
        v.gui = false
      end
      # プロビジョニング用シェルスクリプトを実行(初回のみ)
      server.vm.provision :shell, :inline => script
    end
  end
end
