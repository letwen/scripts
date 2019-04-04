function Add() {
    AliasName=${1};User=${2};Address=${3};Port=${4};Passwd=${5}
    if [[ ${User} == 'root' ]];then
        ssh -p ${Port} ${User}@${Address} mkdir /${User}/.ssh
        sshpass -p ${Passwd} scp -P ${Port} ${p_key} ${User}@${Address}:/${User}/.ssh/
        sshpass -p ${Passwd} ssh -p ${Port} ${User}@${Address} chmod 700 /${User}/.ssh
        sshpass -p ${Passwd} ssh -p ${Port} ${User}@${Address} chmod 600 /${User}/.ssh/${pkey_n}
    else
        ssh -p ${Port} ${User}@${Address} mkdir /home/${User}/.ssh
        sshpass -p ${Passwd} scp -P ${Port} ${p_key} ${User}@${Address}:/home/${User}/.ssh/
        sshpass -p ${Passwd} ssh -p ${Port} ${User}@${Address} chmod 700 /home/${User}/.ssh
        sshpass -p ${Passwd} ssh -p ${Port} ${User}@${Address} chmod 600 /home/${User}/.ssh/${pkey_n}
    fi
    echo " ${AliasName} ${Address} ${Port} ${User}" >> ${path}/host
    cp -a ${s_key} ${path}/key/${AliasName}
}