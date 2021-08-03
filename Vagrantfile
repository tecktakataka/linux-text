# Vagrantfileのロケール環境変数を日本語に設定
ENV["LC_ALL"] = "ja_JP.UTF-8"

user = "taka"

# 各サーバー毎の設定を定義して、それぞれ配列に格納
servers=[
  {
    :servername => "server-1",
    :hostname => "#{user}-1",
    :provision => "config1.sh",
    :network => "network1.sh"
  },
  {
    :servername => "server-2",
    :hostname => "#{user}-2",
    :provision => "config2.sh",
    :network => "network2.sh"
  },
  {
    :servername => "server-3",
    :hostname => "#{user}-3",
    :provision => "config3.sh",
    :network => "network3.sh"
  },
  {
    :servername => "server-4",
    :hostname => "#{user}-4",
    :provision => "config4.sh",
    :network => "network4.sh"
  }
]

Vagrant.configure(2) do |config|
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = "centos/7"
      node.vm.hostname = machine[:hostname]
      node.vm.network "public_network", auto_config: false
      node.vm.provider "virtualbox" do |vb|
        # ヘッドレス起動に設定
        vb.name = machine[:servername]
        vb.gui = false
        vb.memory = "1536"
      end
      # 全台共通の設定スクリプトを実行
      node.vm.provision :shell, "path" => "init.sh"
      # 各サーバー毎の設定スクリプトを実行
      node.vm.provision :shell, "path" => machine[:provision]
      # 各サーバー毎のネットワーク設定スクリプトを実行
      # node.vm.provision :shell, "path" => machine[:network]
    end
  end
end


  # # manual ip
  # config.vm.provision :shell, :path => "network1.sh"
  #   run: "always",
  #   inline: "ifconfig eth1 192.168.11.176 netmask 255.255.255.0 up"
  #   # default router
  #   inline: "route add default gw 192.168.11.1"