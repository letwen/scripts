#!/bin/bash
#Creation time : 2019-02-22 17:36
#Creater and Editer : admin@prcplayer.com
#Last edit time : 2019-02-22 17:44

phpversion='new'	#Set to 'new' to retrieve the new version, set to 'old' to retrieve the old version

function nginxurl() {
	export nginxdownsuffix=`curl -sL https://nginx.org/en/download.html | grep -Po "(?<=href\=\")/download[^\"]+"`
	export nginxdownprefix='https://nginx.org'
}

function nginx() {
	nginxurl
	if [[ ${a} == 'list' ]] || [[ ${a} == '' ]];then
		for list in ${nginxdownsuffix};do echo ${list} | grep -Po "nginx-([0-9]+\.){3}[^$]+";done
	elif [[ ${a} == 'gz' ]];then
		for list in ${nginxdownsuffix};do
			pkgn=`echo ${list} | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.tar.gz"`
				if [[ ${pkgn} == ${b}.tar.gz ]];then
					echo "Detected the relevant source package, start downloading"
					if [[ ${c} != '' ]];then wget -P ${c} https://nginx.org/download/nginx-${b}.tar.gz && exit 0
						else wget https://nginx.org/download/nginx-${b}.tar.gz && exit 0
					fi
				else echo "Source package not detected"
				fi
		done
	elif [[ ${a} == 'zip' ]];then
		for list in ${nginxdownsuffix};do
			pkgn=`echo ${list} | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.zip"`
				if [[ ${pkgn} == ${b}.zip ]];then
					echo "Detected the relevant source package, start downloading"
					if [[ ${c} != '' ]];then wget -P ${c} https://nginx.org/download/nginx-${b}.zip && exit 0
						else wget https://nginx.org/download/nginx-${b}.zip && exit 0
					fi
				else echo "Source package not detected"
			fi
		done
	else
		for list in ${nginxdownsuffix};do
			pkgn=`echo ${list} | grep -Po "nginx-([0-9]+\.){3}[^$]+"`
			if [[ ${pkgn} == ${a} ]];then
				echo "Detected the relevant source package, start downloading"
				if [[ ${b} != '' ]];then wget -P ${b} https://nginx.org/download/${a} && exit 0
					else wget https://nginx.org/download/${a} && exit 0
				fi
			else echo "Source package not detected"
			fi
		done
	fi
}

function phpurl() {
	if [[ ${phpversion} == 'new' ]];then
		export phpdownsuffix=`curl -sL https://php.net/downloads.php | grep -Po "(?<=href\=\")\/distributions[^\"]+" | grep -v "\/get-involved"`
	elif [[ ${phpversion} == 'old' ]];then
		export phpdownsuffix=`curl -sL https://php.net/releases/ | grep -Po "(?<=href\=\")\/distributions[^\"]+" | grep -v "\/get-involved"`
	else echo 'Wrong parameter setting';fi
	export phpdownprefix='https://php.net'
}

function php() {
	phpurl
	if [[ ${a} == 'list' ]] || [[ ${a} == '' ]];then
		for list in ${phpdownsuffix};do echo $list | grep -Po "php-[^$][a-zA-Z0-9\.]+";done
	elif [[ ${a} == 'node' ]];then
		echo 'I didn‘t see the node selection in php.net this time. Maybe you can still try jp2 and hk, etc. Maybe php.net will automatically match the optimal line?'
	elif [[ ${a} == 'xz' ]];then
		for list in ${phpdownsuffix};do
			pkgn=`echo ${list} | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz"`
			if [[ ${pkgn} == ${b}.tar.xz ]];then
				echo "Source package detected,Now use ${phpdownloaddc:-www} node to download"
				phpdownloadurl="https://${phpdownloaddc:-www}.php.net${list}"
				if [[ ${c} != '' ]];then wget -P ${c} ${phpdownloadurl} -O ${c}/php-${pkgn} && exit 0
						else wget ${phpdownloadurl} -O php-${pkgn} && exit 0
				fi
			else
				echo "Source package not detected"
			fi
		done
	elif [[ ${a} == 'gz' ]];then
		for list in ${phpdownsuffix};do
			pkgn=`echo ${list} | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.tar\.gz"`
			if [[ ${pkgn} == ${b}.tar.gz ]];then
				echo "Source package detected,Now use ${phpdownloaddc:-www} node to download"
				phpdownloadurl="https://${phpdownloaddc:-www}.php.net${list}"
				if [[ ${c} != '' ]];then wget -P ${c} ${phpdownloadurl} -O ${c}/php-${pkgn} && exit 0
						else wget ${phpdownloadurl} -O php-${pkgn} && exit 0
				fi
			else
				echo "Source package not detected"
			fi
		done
	elif [[ ${a} == 'bz2' ]];then
		for list in ${phpdownsuffix};do
			pkgn=`echo ${list} | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.tar\.bz2"`
			if [[ ${pkgn} == ${b}.tar.bz2 ]];then
				echo "Source package detected,Now use ${phpdownloaddc:-www} node to download"
				phpdownloadurl="https://${phpdownloaddc:-www}.php.net${list}"
				if [[ ${c} != '' ]];then wget -P ${c} ${phpdownloadurl} -O ${c}/php-${pkgn} && exit 0
						else wget ${phpdownloadurl} -O php-${pkgn} && exit 0
				fi
			else
				echo "Source package not detected"
			fi
		done
	else
		for list in ${phpdownsuffix};do
			pkgn=`echo ${list} | grep -Po "php-[^$][a-zA-Z0-9\.]+"`
			if [[ ${pkgn} == ${a} ]];then
				echo "Source package detected,Now use ${phpdownloaddc:-www} node to download"
				phpdownloadurl="https://${phpdownloaddc:-www}.php.net${list}"
				if [[ ${b} != '' ]];then wget -P ${b} ${phpdownloadurl} -O ${b}/${pkgn} && exit 0
						else wget ${phpdownloadurl} -O ${pkgn} && exit 0
				fi
			else
				echo "Source package not detected"
			fi
		done
	fi
}

case $1 in
	"nginx")
		a=`echo $2`
		b=`echo $3`
		c=`echo $4`
		nginx
		;;
	"php")
		a=`echo $2`
		b=`echo $3`
		if [[ $2 == 'xz' ]] || [[ $2 == 'gz' ]] || [[ $2 == 'bz2' ]];then
			c=`echo $4`
			phpdownloaddc=`echo $5`
		else
			phpdownloaddc=`echo $4`
		fi
		php
		;;
		"help")
		echo "
Help Information
This is a script to quickly download the source package from the source station.
Use：${0} { nginx | php } parameter

nginx parameter :
	list or null : Search all source packages available on nginx.org
	Source_package_name(Such as:nginx-1.15.8.tar.gz) [path] : Download the specified source package,Default download to current path
	gz version(Such as:1.15.8) [path] : Download the specified version of the tar.gz package,Default download to current path
	zip version(Such as:1.15.8) [path] : Download the specified version of the zip package,Default download to current path
	
php parameter :
	list or null : Search all source packages available on php.net
	node : View the available download nodes,the default node is www
	Source_package_name(Such as:php-7.1.26.tar.xz) [path [node]]: Download the specified source package,Default download to current path,The default download node is www
	xz version(Such as:7.1.26) [path [node]] : Download the specified version of the xz package,Default download to current path,The default download node is www
	gz version(Such as:7.1.26) [path [node]] : Download the specified version of the gz package,Default download to current path,The default download node is www
	bz2 version(Such as:7.1.26) [path [node]] : Download the specified version of the bz2 package,Default download to current path,The default download node is www
	
	
php.net changed its rules, now no matter which download node you choose will eventually jump to www, I added a built-in variable, you can modify it to new or old to get different versions of php

Contact Me:
	Email : admin@prcplayer.com
	Blog : prcplayer.com rhel.ink loger.ink
"
	esac
		exit 0
