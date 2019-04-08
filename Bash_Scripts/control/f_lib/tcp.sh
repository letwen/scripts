function tcp() {
        for pkgname in `echo 'epel-release net-tools'`;do
                if ${pre} rpm -qa | grep ${pkgname} >> /tmp/control.log;then
                        echo "${pkgname} has been installed"
                else
                        echo "Depending on ${pkgname} not installed, start installing now"
                        ${pre} yum install ${pkgname} -y
                fi
        done
	${pre} netstat -ntpl
}
