###Ubuntu 服务管理
Ubuntu 中系统没有了RH系统中的 chkconfig 命令。
可用一些小工具来管理 Ubuntu 的启动选项：
####小工具 rcconf：

	sudo apt-get rcconf
	sudo apt-get install rcconf
	
root 下运行: #sudo rcconf

####功能更全的工具：sysv-rc-conf

	sudo apt-get update
	sudo apt-get install sysv-rc-conf
	
运行：#sudo sysv-rc-conf
也可以直接加入启动程序，例如把 /etc/init.d/red5 加入到系统自动启动列表中：
#sudo sysv-rc-conf red5 on
其他使用方法见: google::Ubuntu::sysv-rc-conf 命令用法
也可以直接修改
直接改 /etc/rc0.d ~ /etc/rc6.d 和 /etc/rcS.d 下的东西，S开头的表示启动，K开头的表示不启动，
例如：想关闭 Red5 的开机自动启动，只需 #sudo mv /etc/rc2.d/S20red5 /etc/rc2.d/K20red5 就可以了。
