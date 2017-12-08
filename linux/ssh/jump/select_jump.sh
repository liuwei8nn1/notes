#!/bin/bash

#. /etc/init.d/functions
#. col.fc

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
  #echo -e " \e[1;$2m$1\e[0m"
  #echo -e " \e[0;$2m$1\e[0m"
  #echo -e " \e[1;$2m$1\e[0m"        #Strong
  #echo -e " \e[5;$2m$1\e[0m"        #jump
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}
#-----------------------------------------

Echo_Red_n()
{
  echo -n $(Color_Text "$1" "31")
}

Echo_Green_n()
{
  echo -n $(Color_Text "$1" "32")
}

Echo_Yellow_n()
{
  echo -n $(Color_Text "$1" "33")
}

Echo_Blue_n()
{
  echo -n $(Color_Text "$1" "34")
}

Jump()
{
	clear
	echo "+------------------------------------------------------------------------+"
	echo "|         My_Jump V1.0.0  for  Linux Server, Written by Stone(石头)      |"
	echo "+------------------------------------------------------------------------+"
	echo "|        A tool jump to server & jump to same server  tools on Linux     |"
	echo "+------------------------------------------------------------------------+"
	echo "|        如果您想了解更多信息，  请联系作者:石头      QQ:283302410       |"
	echo "+------------------------------------------------------------------------+"
	Echo_Red_n "====================================="
	Echo_Green "====================================="
	Echo_Yellow_n "====================================="
	Echo_Blue "====================================="
	
	space="    "
	OPSelect="1"
	servernumber=`cat serverlist.txt | grep -v ^# | wc -l`
	Echo_Yellow "您有${servernumber}个选项来选择接下来您希望做什么:"
	#Echo_Yellow "您有3个选项来选择接下来您希望做什么:"
	server_list=(`cat serverlist.txt | grep -v ^#`)
	#echo ${server_list[0]}
	#echo ${server_list[1]}
	for((i=1;i<=${servernumber};i++))
	do
		hostname=`echo ${server_list[$(($i-1))]} | cut -d: -f1`
		hostip=`echo ${server_list[$(($i-1))]} | cut -d: -f2`
		echo -n "${space}${i}: 跳转功能，跳转至"
		Echo_Yellow_n $hostname
		echo -n ",IP为"
		Echo_Blue "$hostip..."
	done
	#echo "${space}1: 跳转功能，跳转至BBbao_Test_Oracle,IP为10.170.7.109..."
	#echo "${space}2: 跳转功能，跳转至BBbao_Test_Oracle,IP为10.170.7.109..."
	Echo_Red "如果没有任何输入，系统将始终停留在此界面，如果要退出，请输入exit退出"

    Echo_Yellow_n "  Enter your choice ("
	for((i=1;i<=${servernumber};i++))
	do
		if [ $i = ${servernumber} ];then
			Echo_Yellow_n "$i or exit): "
		#elif [ $i = $((${servernumber}-1)) ];then
		#	Echo_Yellow_n "$i "
		else
			Echo_Yellow_n "$i, "
		fi
	done
	#Echo_Yellow_n "1, 2 or 8): "
    read OPSelect

    #case "${OPSelect}" in
    #1)
    #    echo "${space}跳转功能，跳转至BBbao_Test_Oracle,IP为10.170.7.109..."
    #;;
    #2)
    #    echo "${space}跳转功能，跳转至BBbao_Test_Oracle,IP为10.170.7.109..."
    #;;
    #exit)
    #    echo "${space}退出"
    #;;
    #*)
    #esac
	
	
	for((i=1;i<=${servernumber};i++))
	do
		if [ "${OPSelect}" = $i ]; then
			hostname=`echo ${server_list[$(($i-1))]} | cut -d: -f1`
			hostip=`echo ${server_list[$(($i-1))]} | cut -d: -f2`
			port=`echo ${server_list[$(($i-1))]} | cut -d: -f3`
			user=`echo ${server_list[$(($i-1))]} | cut -d: -f4`
			password=`echo ${server_list[$(($i-1))]} | cut -d: -f5`
			echo -n "${space}${i}: 跳转功能，跳转至"
			Echo_Yellow_n $hostname
			echo -n ",IP为"
			Echo_Blue "$hostip..."
			#echo "${space}${i}: 跳转功能，跳转至$hostname,IP为$hostip..."
			/usr/bin/expect ./jump.exp $user $hostip $port $password
			exit
		elif [ "${OPSelect}" = "exit" ]; then
			echo "${space}成功退出"
			exit
		#else
		#	Jump
		fi	
	done
	Jump
	
    #if [ "${OPSelect}" = "1" ]; then
	#	serverinfo=`cat serverlist.txt | grep -v ^# | grep BBbao_Test_Oracle`
	#	hostip=`echo $serverinfo | cut -d: -f2`
	#	port=`echo $serverinfo | cut -d: -f3`
	#	user=`echo $serverinfo | cut -d: -f4`
	#	password=`echo $serverinfo | cut -d: -f5`
		#/usr/bin/expect <<-EOF
		#spawn ssh $user@$hostip -p $port
		#expect {
		#"*yes/no" { send "yes\r"; exp_continue }
		#"*password:" { send "$password\r" }
		#}
		#interact
		#expect eof
		#EOF
	#	/usr/bin/expect ./jump.exp $user $hostip $port $password
    #elif [ "${OPSelect}" = "2" ]; then
    #            serverinfo=`cat serverlist.txt | grep -v ^# | grep BBbao_Test_Oracle`
    #            hostip=`echo $serverinfo | cut -d: -f2`
    #            port=`echo $serverinfo | cut -d: -f3`
    #            user=`echo $serverinfo | cut -d: -f4`
    #            password=`echo $serverinfo | cut -d: -f5`
    #            /usr/bin/expect ./jump.exp $user $hostip $port $password
    #elif [ "${OPSelect}" = "exit" ]; then
    #    exit 1
    #else
    #    Jump
    #fi
}

Jump


