#!/bin/bash

# 初期設定開始の案内

echo -e "\n これはネットワーク初期設定のためのシェルスクリプトです。" ; sleep 1

echo -e "\n このスクリプトの実行には管理者権限が必要です。" ; sleep 1

# 管理者権限があるかどうかの確認
while : 

do
  echo -en "\n あなたはrootユーザーですか？あるいはroot権限がありますか？(y/n): " ; read is_root ; echo -en "\n"
  case $is_root in
    'y'|'yes'|'YES'|'Yes') \
       sudo echo " あなたにroot権限があることが確認できました。" ; return_val=$?
         if [ $return_val -eq 0 ] ; then :
         else exit 0
         fi
       echo -e "\n 初期設定を続けます。 " ; break ;;
    'n'|'no'|'NO'|'No')  echo -e "\n 「su -」コマンドを実行して'root'ユーザーになるか、このユーザーにroot権限を与えてから、再度このスクリプトを実行してください。 \n" ; exit 0 ;;
    *)  echo -e "\n 'yes'または'no'を入力してください。\n";;
  esac
done

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 必要な情報の確認
final_check='n'
while [ $final_check != 'y' ] ;

do

  # 出席番号の確認
  while :

  do
    echo -en "\n あなたの出席番号は何番ですか？(1-30): " ; read student_number
    if [[ $student_number -ge 1 ]] && [[ $student_number -le 30 ]] ; then break
    elif [ -z $student_number ] ; then
      # 出席番号のデフォルト値を1に設定。
      student_number=1  
      break
    else
      echo -en "\n  出席番号は'1'から'30'までの範囲で入力してください。\n" ; continue
    fi 
  done

  # サーバー番号の確認
  while :

  do
    echo -en "\n このサーバーは何台目ですか？(1-4): " ; read server_number
    if [[ $server_number -ge 1 ]] && [[ $server_number -le 4 ]] ; then
      break
    elif [ -z $server_number ] ; then
      # サーバー番号のデフォルト値を1に設定。
      server_number=1
      break
    else
      echo -en "\n  '1'から'4'までの範囲で入力してください。\n" 
    fi
  done

  # ホスト名の確認
  echo -en "\n このサーバーに設定したいホスト名を入力してください。(デフォルト: $USER): " ; read host_name
    if [ -z $host_name ] ; then
      # ホスト名のデフォルト値をユーザー名に設定。
      host_name=$USER
    fi

  # 設定の確認
  while : 

  do
    echo -e "\n  出席番号: $student_number, サーバー番号: $server_number, ホスト名: $host_name-$server_number"
    echo -en "\n この設定でよろしいですか？(y/n): "; read verify
    case $verify in
      'y'|'yes'|'YES'|'Yes')  echo -e "\n 入力された情報を元にネットワーク設定を行います。" ; final_check='y'
        break ;;
      'n'|'no'|'NO'|'No')  echo -e "\n  設定をやり直します。" ; final_check='n'
        break ;; 
      *)  echo -e "\n 'yes'または'no'を入力してください。\n"
        continue ;;
    esac
  done
done

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 入力された内容を元にnmcliコマンドを実行する
echo -e "\n ネットワーク設定を反映しています。" ; sleep 1
echo -e "\n 処理が終わるまでこのままお待ちください。\n" ; sleep 1

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 変数設定
HOST_NAME=${host_name}-${server_number}
IP_ADDRESS="192.168.19.$((student_number*4+124+(server_number-1)))/24"
DNS="192.168.19.1"
GATEWAY="192.168.19.1"
INTERFACE="enp0s3"

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# nmcliコマンドの実行

function network_setting() {
# ホスト名の設定
sudo nmcli general hostname $HOST_NAME && \
# スタティックアドレスの設定
nmcli con mod $INTERFACE ipv4.addresses "$IP_ADDRESS" && \
# デフォルトゲートウェイの設定
nmcli con mod $INTERFACE ipv4.gateway $GATEWAY && \
# DNSの設定
nmcli con mod $INTERFACE ipv4.dns $DNS && \
# IPを固定割り当てに設定
nmcli con mod $INTERFACE ipv4.method manual && \
# インタフェースの自動起動を有効化
nmcli con mod $INTERFACE connection.autoconnect yes && \
# インタフェースを再起動して設定を反映
nmcli con down $INTERFACE ; nmcli con up $INTERFACE;
}

network_setting

echo -e -n "\n" && \
# 確認のため現在の設定を表示
nmcli device show $INTERFACE && \
echo -e "\n ネットワーク設定が完了しました。\n"
