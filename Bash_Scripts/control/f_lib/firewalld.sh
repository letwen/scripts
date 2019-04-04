function firewalld() {
    Fcmd=$1
    Ftype=$2
    Faims=$3
    if [[ ${Fcmd} == 'list' ]];then
        ${pre} firewall-cmd --list-all
    elif [[ ${Fcmd} == 'add' ]];then
        if [[ ${Ftype} == 'port' ]];then
            ${pre} firewall-cmd --permanent --add-port=${Faims}
        elif [[ ${Ftype} == 'service' ]];then
            ${pre} firewall-cmd --permanent --add-service=${Faims}
        else echo "错误的语句"
        fi
    elif [[ ${Fcmd} == 'remove' ]];then
            if [[ ${Ftype} == 'port' ]];then
                    ${pre} firewall-cmd --permanent --remove-port=${Faims}
            elif [[ ${Ftype} == 'service' ]];then
                    ${pre} firewall-cmd --permanent --remove-service=${Faims}
            else echo "错误的语句"
            fi
    elif [[ ${Fcmd} == 'stop' ]];then
        ${pre} systemctl stop firewalld
    elif [[ ${Fcmd} == 'start' ]];then
        ${pre} systemctl start firewalld
    elif [[ ${Fcmd} == 'reload' ]];then
        ${pre} firewall-cmd --reload
    else echo "错误的语句"
    fi
}