#!/bin/bash
#Installation of php\nginx\bbr
#Edited by letwen
#date : 2018-12-06

#Create variable
cpunum=`cat /proc/cpuinfo| grep "processor"| wc -l`

nginxmod=`echo $4`

nginxV='1.14.2';phpV='7.2.16'
if [ -z $2 ];then echo -e "Default version:\n\tnginx:${nginxV}\n\tphp:${phpV}";else nginxV="$2";phpV="$2";fi

nginxconfdir='/etc/nginx'
phpconfdir='/etc/php'

if `ls /usr/sbin/nginx &> /dev/null`;then nginxnow=`nginx -v 2>&1 | grep -Po "(?<=nginx version\: nginx\/)[0-9\.]+"`;fi
if `ls /usr/bin/php &> /dev/null`;then phpnow=`php -v | grep -Po "(?<=PHP )[0-9\.]+"`;fi

nginxurl="https://code.aliyun.com/letwen/scripts/raw/master/Source_Package/nginx-${nginxV}.tar.gz"
phpurl="https://code.aliyun.com/letwen/scripts/raw/master/Source_Package/php-${phpV}.tar.gz"
if [ -z $3 ];then echo "The default download source is alicode repository";else 
	if [[ $3 == 'g' ]];then
		nginxurl="https://github.com/letwen/scripts/raw/master/Source_Package/nginx-${nginxV}.tar.gz"
		phpurl="https://github.com/letwen/scripts/raw/master/Source_Package/php-${phpV}.tar.gz"
	else echo "Wrong input";fi
fi

webuser="wwwpub"

nginxpkn="nginx-${nginxV}.tar.gz";phppkn="php-${phpV}.tar.gz"

nginxdir="/nginx-${nginxV}";phpdir="/php-${phpV}"

srcdir='/usr/local/src';insdir='/usr/local'

nginxc="./configure --prefix=${insdir}${nginxdir} --sbin-path=${insdir}${nginxdir}/sbin/nginx --conf-path=${insdir}${nginxdir}/etc/nginx.conf --error-log-path=/var/log/nginx/error.logs --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=${insdir}${nginxdir}/cache/client_temp --http-proxy-temp-path=${insdir}${nginxdir}/cache/proxy_temp --http-fastcgi-temp-path=${insdir}${nginxdir}/cache/fastcgi_temp --http-uwsgi-temp-path=${insdir}${nginxdir}/cache/uwsgi_temp --http-scgi-temp-path=${insdir}${nginxdir}/cache/scgi_temp --user=${webuser} --group=${webuser} --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module $nginxotr"
phpc="./configure --prefix=${insdir}${phpdir} --with-config-file-path=${insdir}${phpdir}/etc --enable-fpm --with-fpm-user=${webuser} -with-fpm-group=${webuser} -with-mysqli=mysqlnd --with-pdo-mysql --enable-mysqlnd --with-zlib --with-gd --with-png-dir --with-jpeg-dir --with-gettext --with-freetype-dir --with-openssl --with-curl --enable-exif --enable-sockets --enable-bcmath --enable-mbstring --enable-pcntl --enable-calendar --enable-opcache --enable-zip"

nginxservice="[Unit]
Description=The nginx HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=${insdir}/nginx/sbin/nginx -t
ExecStart=${insdir}/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true
[Install]
WantedBy=multi-user.target"
phpservice="[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target
[Service]
Type=simple
PIDFile=/run/php-fpm.pid
ExecStart=/bin/nice --10 ${insdir}/php/sbin/php-fpm --nodaemonize --fpm-config ${insdir}/php/etc/php-fpm.conf -c ${insdir}/php/etc/php.ini
ExecReload=/bin/kill -USR2 \$MAINPID
ExecStop=/bin/kill \$MAINPID
[Install]
WantedBy=multi-user.target"

function testconf() {
if [[ $? != 0 ]];then echo "Error in execution, please check the error message" && exit 2;fi
}

#Installation dependency
function ready() {
	if `rpm -qa | grep epel &> /dev/null`;then echo "Epel extension source is installed";else
		rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;testconf
		yum clean all && yum makecache fast;testconf
	fi

	yum install wget curl git screen gcc-c++ -y;testconf
}

function userc() {
	if `cat /etc/passwd | grep ${webuser} &> /dev/null`;then echo "Web user already exists";else useradd ${webuser};fi
}

function nginx() {
#Determine if the current version is installed
	if [[ ${nginxnow} == ${nginxV} ]];then echo -e "Current version: ${nginxV} is installed";exit 2;fi
#Installation dependency
	yum install zlib pcre pcre-devel openssl openssl-devel gcc gcc-c++ -y;testconf
#Create user
	userc
#Download the nginx source package
	wget -P ${srcdir} ${nginxurl};testconf
#Start compiling and installing
	cd ${srcdir}
	tar xf ${nginxpkn};testconf
#ldap mod add
if [ $nginxmod = 'ldap' ];then
	cd ${srcdir}${nginxdir}/src && git clone https://github.com/kvspb/nginx-auth-ldap.git
	nginxa="./configure --prefix=${insdir}${nginxdir} --sbin-path=${insdir}${nginxdir}/sbin/nginx --conf-path=${insdir}${nginxdir}/etc/nginx.conf --error-log-path=/var/log/nginx/error.logs --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=${insdir}${nginxdir}/cache/client_temp --http-proxy-temp-path=${insdir}${nginxdir}/cache/proxy_temp --http-fastcgi-temp-path=${insdir}${nginxdir}/cache/fastcgi_temp --http-uwsgi-temp-path=${insdir}${nginxdir}/cache/uwsgi_temp --http-scgi-temp-path=${insdir}${nginxdir}/cache/scgi_temp --user=${webuser} --group=${webuser} --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-stream --with-stream_ssl_module --with-http_slice_module --with-mail --with-mail_ssl_module --with-file-aio --with-http_v2_module --add-module=${srcdir}${nginxdir}/src/nginx-auth-ldap"
	cd ${srcdir}${nginxdir} && $nginxa;testconf
else
	cd ${srcdir}${nginxdir} && $nginxc;testconf
fi
#allow install
	make -j${cpunum};testconf
	make install;testconf
#Brief configuration after installation is complete
	mkdir -p ${insdir}${nginxdir}/cache/client_temp
	chown -R ${webuser}:${webuser} ${insdir}${nginxdir}/cache && chmod -R 777 ${insdir}${nginxdir}/cache
	if [ -d ${nginxconfdir} ];then
		tar zcvf ${insdir}${nginxdir}/etc.default.tar.gz ${insdir}${nginxdir}/etc && rm -rf ${insdir}${nginxdir}/etc/* && cp -r ${nginxconfdir}/* ${insdir}${nginxdir}/etc/
	fi
	rm -rf ${insdir}/nginx
	ln -sf ${insdir}${nginxdir} ${insdir}/nginx
	if `ls /etc/nginx &> /dev/null`;then echo "Profile directory already exists";else
		ln -sf /usr/local/nginx/etc /etc/nginx
	fi
	ln -sf /usr/local/nginx/sbin/* /usr/sbin/
	echo -e "${nginxservice}" > /usr/lib/systemd/system/nginx.service
	systemctl enable nginx
	echo -e "\n\n\nThe installation is complete
installation path:${insdir}${nginxdir}
Connect to the execution path:${insdir}/nginx
etc path:/etc/nginx"
}

function php() {
#Installation dependency
	yum install -y libxml2-devel libvpx-devel libjpeg-devel libpng-devel freetype-devel mysql-devel mysql libmcrypt-devel openssl-devel libcurl-devel;testconf
#Create user
	userc
#Download the nginx source package
	wget -P ${srcdir} ${phpurl};testconf
#Start compiling and installing
	cd ${srcdir}
	tar xf ${phppkn};testconf
	cd ${srcdir}${phpdir} && $phpc;testconf
	make -j${cpunum};testconf
	make install;testconf
#Brief configuration after installation is complete
	if [ -d ${phpconfdir} ];then
		tar zcvf ${insdir}${phpdir}/etc.default.tar.gz ${insdir}${phpdir}/etc && rm -rf ${insdir}${phpdir}/etc/* && cp -r ${phpconfdir}/* ${insdir}${phpdir}/etc/
	fi
	rm -rf ${insdir}/php
	ln -sf ${insdir}${phpdir} ${insdir}/php
	if `ls /etc/php &> /dev/null`;then echo "Profile directory already exists";else
		ln -sf ${insdir}${phpdir}/etc /etc/php
	fi
	ln -sf ${insdir}${phpdir}/bin/* /usr/bin/
	ln -sf ${insdir}${phpdir}/sbin/* /usr/sbin
	echo -e "${phpservice}" > /etc/systemd/system/php-fpm.service
	cp ${srcdir}${phpdir}/php.ini-production /etc/php/php.ini
	cp /etc/php/php-fpm.conf.default /etc/php/php-fpm.conf
	cp /etc/php/php-fpm.d/www.conf.default /etc/php/php-fpm.d/www.conf
	#echo -e "extension = mbstring.so\n" >> /etc/php/php.ini
	echo -e "zend_extension=opcache.so
	opcache.enable=1
	opcache.enable_cli=1
	opcache.file_cache=/home/opcache
	opcache.huge_code_pages=1" >> /etc/php/php.ini
	mkdir /home/opcache && chown -R ${webuser}:${webuser} /home/opcache
	systemctl enable php-fpm
	echo -e "\n\n\nThe installation is complete
installation path:${insdir}${phpdir}
Connect to the execution path:${insdir}/php
etc path:/etc/php"
}

function kerup() {
#Install the new  kernel
	if `rpm -qa | grep elrepo-release &> /dev/null`;then echo "Elrepo-release yum source installed";else
	rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org;testconf
	rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm;testconf
	fi
	yum --enablerepo=elrepo-kernel install kernel-ml -y;testconf
}

function bbr() {
	if `cat /etc/sysctl.conf | grep 'net.core.default_qdisc=fq' &> /dev/null`;then echo 'net.core.default_qdisc=fq statement already exists';else
		echo 'net.core.default_qdisc=fq' >> /etc/sysctl.conf;fi
	if `cat /etc/sysctl.conf | grep 'net.ipv4.tcp_congestion_control=bbr' &> /dev/null`;then echo 'net.ipv4.tcp_congestion_control=bbr statement already exists';else
		echo 'net.ipv4.tcp_congestion_control=bbr' >> /etc/sysctl.conf;fi
	echo "bbr installation is complete, you may need to install the latest version of the kernel to enable"

}

softlist='nginx php bbr'

if [[ $1 == '-h' ]];then
	echo '快速安装nginx\php\google-brr
使用脚本前请先使用ready参数来安装脚本的依赖

安装nginx和php的格式：install_nginx_php_bbr.sh {nginx|php} [version] [g]
	version指定安装的版本，默认安装版本为nginx-1.14.2，php-7.2.16
	支持的版本可以到项目目录下查看
	如果带有g参数则表名使用github的仓库来安装，不指定则默认使用aliyun仓库
	支持ldap模块的安装，如果需要安装ldap模块则需要指定g参数，然后在g参数之后添加ldap参数
	

安装google-bbr：需要先升级内核，然后安装bbr
	升级内核使用kerup参数，升级完成后需要手动指定版本并重启
		egrep ^menuentry /etc/grub2.cfg | cut -f 2 -d	#查询现有的内核版本
		grub2-set-default 位置		#位置从0开始
	安装bbr：使用bbr参数，安装完成后需要重启
'
	elif [[ $1 == 'nginx' ]] || [[ $1 == 'php' ]] || [[ $1 == 'kerup' ]] || [[ $1 == 'bbr' ]];then $1;
	elif [[ $1 == 'ready' ]];then ready
	else echo "Wrong input"
fi
