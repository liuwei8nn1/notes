安装依赖
	yum install gcc
	yum install pcre-devel
	yum install zlib zlib-devel
	yum install openssl openssl-devel
	//一键安装上面四个依赖
	yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
	
下载nginx的tar包
	//创建一个文件夹
	cd /usr/local
	mkdir nginx
	cd nginx
	//下载tar包
	wget http://nginx.org/download/nginx-1.13.7.tar.gz
	tar -xvf nginx-1.13.7.tar.g

安装nginx
	//进入nginx目录
	cd /usr/local/nginx
	//执行命令
	./configure
	//执行make命令
	make
	//执行make install命令
	make install
	
Nginx常用命令
	//测试配置文件
	安装路径下的/nginx/sbin/nginx -t
	
	//启动命令
	安装路径下的/nginx/sbin/nginx
	//停止命令
	安装路径下的/nginx/sbin/nginx -s stop
	或者 : nginx -s quit
	//重启命令
	安装路径下的/nginx/sbin/nginx -s reload
	
	//查看进程命令
	ps -ef | grep nginx
	//平滑重启
	kill -HUP Nginx主进程号
	
配置防火墙
	//打开防火墙文件
	sudo vim /etc/sysconfig/iptables
	//新增行  开放80端口
	-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
	//保存退出
	//重启防火墙
	sudo service iptables restart
	
Nginx虚拟域名配置及测试验证
	//编辑nginx.conf
	sudo vim /usr/local/nginx/conf/nginx.conf
	//增加行 
	include vhost/*.conf
	//保存退出
	//在/usr/local/nginx/conf目录新建vhost文件夹
	mkdir vhost
	//创建每个域名的配置
	sudo vim jimisun.com.conf
	//节点中增加入响应的配置 端口转发  或者访问文件系统

Nginx启动
	//进入nginx安装目录
	cd sbin
	sudo ./nginx
	测试访问
	http://ip地址
	
Nginx安装ssl
   1. /usr/local/nginx/sbin/nginx -V 查看nginx版本与编译安装了哪些模块
	nginx version: nginx/1.10.3
	built by gcc 4.4.7 20120313 (Red Hat 4.4.7-18) (GCC)
	built with OpenSSL 1.0.1e-fips 11 Feb 2013
	TLS SNI support enabled
	configure arguments:


	2. 下载nginx 1.10.3, 并且configure
	./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module


	3. 执行make ，千万不要make install 否则会覆盖现有的nginx


	4. 关闭nginx

	5. copy  ~/download/nginx-1.10.3/objs/nginx 到现有的/usr/local/nginx/sbin/nginx


	6. /usr/local/nginx/sbin/nginx -V 查看编译安装的模块
	nginx version: nginx/1.10.3
	built by gcc 4.4.7 20120313 (Red Hat 4.4.7-18) (GCC)
	built with OpenSSL 1.0.1e-fips 11 Feb 2013
	TLS SNI support enabled
	configure arguments: --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module



	7. 修改nginx.conf文件

	server {
	  server_name xxx.yyy.com;
	  listen 443;
	  ssl on;
	  ssl_certificate /usr/local/nginx/conf/xxx.com_server.txt; #公钥
	  ssl_certificate_key /usr/local/nginx/conf/xxx.com_private.txt; #私钥

	  location / {
		  # location的一堆配置
		  # 
		  #
		  # ################
	  }

	  error_page   500 502 503 504  /50x.html;
	  location = /50x.html {
		  root   html;
	  }
	}
	###########################80端口的处理###############################
	server {
	  listen 80;
			server_name  xxx.yyy.com;
			send_timeout 1800;

			rewrite ^(.*)$  https://xxx.yyy.com$1 permanent; # 80端口跳转
	}
	
	