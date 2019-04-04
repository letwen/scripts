function udp() {
	for pkgname in `echo 'epel-release net-tools'`;do
                if rpm -qa | grep ${pkgname} >> /tmp/control.log;then
                        echo "${pkgname} has been installed"
                else
                        echo "Depending on ${pkgname} not installed, start installing now"
                        yum install ${pkgname} -y
                fi
        done
	${pre} netstat -nupl
}
