#!/bin/bash

#. /etc/init.d/functions
#. col.fc

function color(){
    blue="\033[0;36m"
    red="\033[0;31m"
    green="\033[0;32m"
    close="\033[m"
    case $1 in
        blue)
            echo -e "$blue $2 $close"
        ;;
        red)AA
            echo -e "$red $2 $close"
        ;;
        green)
            echo -e "$green $2 $close"
        ;;
        *)
            echo "Input color error!!"
        ;;
    esac
}

function copyright(){
    echo "#############################"
    color blue "   SSH Login Platform   "
    echo "#############################"
    echo
}

function underline(){
    echo "-----------------------------------------------------"
}
printList(){
	direc=`dirname $0`
	echo "    Jump V1.0.0 for Linux Server By alan "
	underline
	echo "  id |  hostName |  ip or host   | port | desc"	
    awk 'BEGIN {FS=":"} {printf("\033[0;31m% 3s \033[m |%10s |%10s |%5s |%10s \n",$1,$2,$3,$4,$6)}' $direc/server.lst
	underline
}

main()
{
while [ True ];do	
	clear
	printList
	#if [ -n "$errMsg" ];then
	#	echo "errMsg = $errMsg"
	#fi
	if [ "$errMsg"x != ""x ];then
		echo "errMsg = $errMsg"
	fi
	read -p '[*] 选择主机(quit/q): ' number
    pw="$direc/server.lst"
    ipaddr=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $3}}' $pw)
    port=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $4}}' $pw)
    username=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $5}}' $pw)
    passwd=$(awk -v num=$number 'BEGIN {FS=":"} {if($1 == num) {print $6}}' $pw)
	servernumber=`cat server.lst | wc -l`
	case $number in
		[0-9]|[0-9][0-9]|[0-9][0-9][0-9])
			if [ $servernumber -lt $number ];then
				errMsg="Input error!"
			else
				errMsg=""	
			    echo $passwd | grep -q ".pem$"
			    RETURN=$?
			    if [[ $RETURN == 0 ]];then
			        ssh -i $direc/keys/$passwd $username@$ipaddr -p $port
			        echo "ssh -i $direc/$passwd $username@$ipaddr -p $port"
			    else
			        expect -f $direc/ssh_login.exp $ipaddr $username $passwd $port
			    fi
			fi
	    ;;
	    "q"|"quit")
	        exit
	    ;;

	    *)
	        errMsg="Input error!!"
	    ;;
	esac
	
done
}
copyright
main
