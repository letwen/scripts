#!/bin/bash
host=$1
doinfo=$2
path=`dirname $0`
if `cat ${path}/host | grep -Po "[ ]${host}[ ]" >> /tmp/control.log`;then
	chmod 700 ${path}/key
	chmod 600 ${path}/key/*
	chown root.root ${path}/key -R
	Port=`cat ${path}/host | grep ${host} | awk 'FS=" "{print $3}'`
	Host=`cat ${path}/host | grep ${host} | awk 'FS=" "{print $2}'`
	User=`cat ${path}/host | grep ${host} | awk 'FS=" "{print $4}'`
	Key="${path}/key/${host}"
	pre="ssh -p ${Port} -i ${Key} ${User}@${Host}"
elif [[ ${host} == 'add' ]];then
	SSHIF="${path}/ssh_keygen"
        skey_n='id_rsa'
        pkey_n='authorized_keys'
        s_key="${SSHIF}/${skey_n}"
        p_key="${SSHIF}/${pkey_n}"
	for pkgname in `echo 'epel-release sshpass'`;do
		if rpm -qa | grep ${pkgname} >> /tmp/control.log;then
			echo "${pkgname} has been installed"
		else
			echo "Depending on ${pkgname} not installed, start installing now"
			yum install ${pkgname} -y
		fi
	done
	AliasName=${2};User=${3};Address=${4};Port=${5};Passwd=${6}
	source ${path}/f_lib/Add.sh
	Add ${AliasName} ${User} ${Address} ${Port} ${Passwd}
elif [[ ${host} == 'check' ]];then
	source ${path}/f_lib/check.sh
	check
elif [[ ${host} == 'help' ]];then
	echo '命令格式：control {host|help|add} {command} ......

保留别名：check/add/help
如果强行使用保留别名可能会出现未知错误

add参数格式：control add 别名 用户名 地址 端口 密码
	#为了适配，密码在脚本运行时会使用交互式界面要求再次输入
	#以上参数缺一不可，并且必须按照说明格式
	#公钥和密钥会使用ssh_keygen目录下的authorized_keys和id_rsa文件
	#地址需要输入本机可以访问的地址
	#为了避免对本机带来损害，请严格按照格式和要求操作

check：检查host文件和key文件夹，如果没有会自动创建

help：查看帮助信息

host参数列表
	ssrconfig：检查ssr配置文件

	ssrrun：重新启动ssr

	firewalld：配置firewalld防火墙
		格式：control host firewalld {list|add|remove|stop|start|reload} [service|port/{tcp/udp}]

	tcp：查看开启的tcp端口

	udp：查看开启的udp端口

	yum：yum配置
		格式:control host yum {install|remove|update|upgrade} [pkgname]
		只有当指定{install|remove}时需要指定包名，每次至多可以输入5个包名

	hostanme：配置主机名
		格式：control hostname 主机名

	reboot：重启服务器

	shutdown：关闭服务器
	
	nginx：nginx相关操作
		格式：control host nginx {install|version|start|stop|enable|disable|reload|check|restart}
		#支持管理功能，但目前仓库内已有安装脚本，故此不提供安装功能
'
else
	echo "配置文件中没有找到相应的主机"
fi

#System must be loaded last
source ${path}/f_lib/System.sh
