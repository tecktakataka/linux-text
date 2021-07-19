#!/bin/bash

# 初期設定開始の案内

echo -e "\n This is the script for the initial configuration of the network. " ; sleep 1

echo -e "\n You need to have 'root' permission to execute this script." ; sleep 1

# 管理者権限があるかどうかの確認
while : 

do
  echo -en "\n Are you 'root' user? Or, Do you have the 'root' permission?(y/n): " ; read is_root ; echo -en "\n"
  case $is_root in
    'y'|'yes'|'YES'|'Yes') \
       sudo echo " root check OK." ; return_val=$?
         if [ $return_val -eq 0 ] ; then :
         else exit 0
         fi
       echo -e "\n Continue with the initial setup. " ; break ;;
    'n'|'no'|'NO'|'No')  echo -e "\n Execute 'su -' command to be 'root' user, or Arrow this user to execute the command for 'root' user. \n" ; exit 0 ;;
    *)  echo -e "\n Please enter 'yes' or 'no'.\n";;
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
    echo -en "\n What is your student number?(1-30): " ; read student_number
    if [[ $student_number -ge 1 ]] && [[ $student_number -le 30 ]] ; then break
    elif [ -z $student_number ] ; then
      student_number=1  
      break
    else
      echo -en "\n  Please enter 'between 1 to 30'.\n" ; continue
    fi 
  done

  # サーバー番号の確認
  while :

  do
    echo -en "\n What number is this server?(1-4): " ; read server_number
    if [[ $server_number -ge 1 ]] && [[ $server_number -le 4 ]] ; then
      break
    elif [ -z $server_number ] ; then
      server_number=1
      break
    else
      echo -en "\n  Please enter 'between 1 to 4'.\n" 
    fi
  done

  # ホスト名の確認
  echo -en "\n Enter the hostname you would like to set for this server.(default: $USER): " ; read host_name
    if [ -z $host_name ] ; then
      host_name=$USER
    fi

  # 設定の確認
  while : 

  do
    echo -e "\n  Class number: $student_number, Server number: $server_number, Host name: $host_name-$server_number"
    echo -en "\n Are you sure you would like to use this setting?(y/n): "; read verify
    case $verify in
      'y'|'yes'|'YES'|'Yes')  echo -e "\n Configure the network settings based on these details." ; final_check='y'
        break ;;
      'n'|'no'|'NO'|'No')  echo -e "\n  Redo the settings." ; final_check='n'
        break ;; 
      *)  echo -e "\n Please enter 'yes' or 'no'.\n"
        continue ;;
    esac
  done
done

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 入力された内容を元にnmcliコマンドを実行する
echo -e "\n Initializing the network settings." ; sleep 1
echo -e "\n Please wait until the process is finished.\n" ; sleep 1

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
echo -e "\n Network settings are now complete!\n"
