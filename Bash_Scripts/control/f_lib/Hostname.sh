function Hostname() {
    Htn=$1
    ${pre} hostnamectl set-hostname ${Htn}
}