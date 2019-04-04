function Nginx() {
	Act=$1
	if [[ ${Act} == 'install' ]];then
		echo "暂不支持的功能"
	elif [[ ${Act} == 'version' ]];then
		${pre} nginx -v
	elif [[ ${Act} == 'start' ]];then
		${pre} systemctl start nginx
	elif [[ ${Act} == 'stop' ]];then
		${pre} systemctl stop nginx
	elif [[ ${Act} == 'enable' ]];then
		${pre} systemctl enable nginx
	elif [[ ${Act} == 'disable' ]];then
		${pre} systemctl disable nginx
	elif [[ ${Act} == 'reload' ]];then
		${pre} nginx -s reload
	elif [[ ${Act} == 'check' ]];then
		${pre} nginx -t
	elif [[ ${Act} == 'restart' ]];then
		${pre} systemctl restart nginx
	fi
}
