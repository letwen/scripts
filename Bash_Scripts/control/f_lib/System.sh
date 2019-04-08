case ${doinfo} in
        "reboot")
		source ${path}/f_lib/Reboot.sh
                Reboot
                ;;
        "shutdown")
		source ${path}/f_lib/Shutdown.sh
                Shutdown
                ;;
        "ssrconfig")
		source ${path}/f_lib/ssrconfig.sh
                ssrconfig       
                ;;
        "ssrrun")
		source ${path}/f_lib/ssrrun.sh
                ssrrun
                ;;
        "login")
		source ${path}/f_lib/login.sh
                login
                ;;
        "firewalld")
		source ${path}/f_lib/firewalld.sh
                firewalld $3 $4 $5
                ;;
        "tcp")
		source ${path}/f_lib/tcp.sh
                tcp
                ;;
        "udp")
		source ${path}/f_lib/udp.sh
                udp
                ;;
        "yum")
		source ${path}/f_lib/yum.sh
                yum $3 $4 $5 $6 $7 $8
                ;;
        "hostname")
		source ${path}/f_lib/Hostname.sh
                Hostname $3
                ;;
	"nginx")
		source ${path}/f_lib/Nginx.sh
		Nginx $3
		;;
        esac
                echo "执行完毕"
