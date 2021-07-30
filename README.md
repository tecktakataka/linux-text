〇Vagrantをインストール
〇Git-for-Windowsをインストール
〇ssh-keyの設定
〇windowsのfirewallの変更

〇Windows(ホストOS)でgitbashを起動
〇任意の場所に、Vagrant実行環境用のディレクトリを作成
〇作成したディレクトリ内で「$ vagrant init」
→Vagrant実行に必要なファイルが作成される
〇(↑上記のコマンドで作成された)「Vagrant file」を、事前に作成した「Vagrant file」で上書きする
〇「Vagrant file」内の変数(出席番号や名前)を自分に合ったものに置き換える
〇「$ vagrant up」
→サーバー作成＆全サーバー起動(プロンプトが戻るまで待つ)
〇「$ vagrant status」
→現在の状況を確認
〇「$ vagrant ssh [サーバー名]
→指定したサーバーに簡単にsshログイン可能
〇「$ vagrant halt」
→全サーバー停止
