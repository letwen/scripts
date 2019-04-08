function User() {
        Act=$1
        Uname=$2
        Pkey=$3
        if [[ ${Act} == 'add' ]];then
                if [[ ${Pkey} == "" ]];then
                        Pkey="${path}/ssh_keygen/authorized_keys_user"
                elif [ -f ${Pkey} ];then
                        echo "已检测到文件"
                else
                        echo "错误的语句或文件不存在";exit 2
                fi
                ${pre} useradd ${Uname}
                ${pre} mkdir /home/${Uname}/.ssh
                scp -P ${Port} -i ${Key} ${Pkey} ${User}@${Host}:/home/${Uname}/.ssh/authorized_keys
                ${pre} chown -R /home/${Uname}/.ssh
                ${pre} chmod 700 /home/${Uname}/.ssh
                ${pre} chmod 600 /home/${Uname}/.ssh/*
        elif [[ ${Act} == 'del' ]];then
                if [[ ${Pkey} == 'dir' ]];then
                        ${pre} userdel -r ${Uname}
                else
                        ${pre} userdel ${Uname}
                fi
        else echo "错误的语句";exit 2
        fi
}
