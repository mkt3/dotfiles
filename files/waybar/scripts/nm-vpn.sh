#!/usr/bin/env sh
nmcli -t connection show --active | awk -F ':' '
$3=="wireguard" {
    name=$1
    status="ON"
}
$3=="vpn" {
    name=$1
    status="ON"
}
END {if(status) printf("%s", name)}'
