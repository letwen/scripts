case ${doinfo} in
        "reboot")
                Reboot
                ;;
        "shutdown")
                Shutdown
                ;;
        "ssrconfig")
                ssrconfig       
                ;;
        "ssrrun")
                ssrrun
                ;;
        "login")
                login
                ;;
        "firewalld")
                firewalld $3 $4 $5
                ;;
        "tcp")
                tcp
                ;;
        "udp")
                udp
                ;;
        "yum")
                yum $3 $4 $5 $6 $7 $8
                ;;
        "hostname")
                Hostname $3
                ;;
        esac
                echo "blog : prcplayer.com  rhel.ink  loger.ink"
