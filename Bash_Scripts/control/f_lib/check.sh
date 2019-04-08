function check() {
	if [ -f ${path}/host ];then
		echo -e "host文件检测成功\n"
	else
		echo -e "host文件检测失败，将创建host文件\n"
		touch ${path}/host
	fi

	if [ -d ${path}/key ];then
                echo -e "key文件夹检测成功\n"
        else
                echo -e "key文件夹检测失败，将创建key文件夹\n"
                mkdir ${path}/key
        fi
}
