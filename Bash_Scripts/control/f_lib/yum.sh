function yum() {
    Command=$1
    Pkg="$2 $3 $4 $5 $6"
    if [[ ${Command} == 'install' ]] || [[ ${Command} == 'remove' ]] || [[ ${Command} == 'update' ]] || [[ ${Command} == 'upgrade' ]];then
        ${pre} yum ${Command} ${Pkg} -y
    else echo "输入错误";exit 2
    fi
}
