# yum -y update && \
# プロビジョニング用シェルスクリプトを定義
script = <<SCRIPT
systemctl stop firewalld.service ; \
yum -y install bind bind-chroot bind-utils && \
yum -y install httpd tree tmux && \
systemctl start named-chroot.service && \
systemctl enable named-chroot.service && \
systemctl start firewalld.service && \
systemctl start httpd.service && \
systemctl enable httpd.service && \
systemctl enable firewalld.service && \
firewall-cmd --permanent --add-service=dns && \
firewall-cmd --permanent --add-service=http && \
firewall-cmd --reload && \
echo 'setup is now complete!'
SCRIPT

Vagrant.configure("2") do |config|
  # boxに利用するゲストOSを定義(全ゲストOS共通)
  config.vm.box = "centos/7"

  # each文を利用して、サーバーを4台作成
  (1..4).each do |i|
    # ブロック変数内で利用するローカル変数を定義
    # server変数に1~4を代入
    server = "server-#{i}"
    # hostname変数に1~4を代入
    hostname = "taka-#{i}"
    # ip_address 変数に"192.168.99.110,120,130,140"を代入
    ip_address = "192.168.99.1#{i}0"

    config.vm.define "#{server}" do |server|
    # ホスト名を設定
    server.vm.hostname = "#{hostname}"
    # (デフォルトのNATに加えて、)ブリッジネットワークを設定
    # IPアドレスを設定 / ネットワークの自動起動を設定(デフォルトでもON)
    server.vm.network :private_network, ip: "#{ip_address}", auto_config: true

    server.vm.provider :virtualbox do |v|
      # VirtualBoxのメモリを1536MBに設定
      v.memory = "1536"
      # GUI起動に設定
      v.gui = true
    end
      # プロビジョニング用シェルスクリプトを実行(初回のみ)
      server.vm.provision :shell, :inline => script
    end
  end
end