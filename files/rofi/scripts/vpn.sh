#!/usr/bin/env bash
set -E
set -e
set -o pipefail

declare -A CONNECTION_DICT

declare SELECTED_CONNECTION=""

determine_connection_list(){
    local active_connections=""
    local available_connections=""

    available_connections=$(nmcli --mode tabular --terse connection show | grep -E "(vpn|wireguard)" | cut -d ":" -f1) || true

    if [[ $available_connections ]]; then
        for connection in "${available_connections[@]}"
        do
            CONNECTION_DICT[$connection]="Inactive"
        done
    fi

    active_connections=$(nmcli --mode tabular --terse connection show --active | grep -E "(vpn|wireguard)" | cut -d ':' -f1) || true
    if [[ $active_connections ]]; then
        for connection in "${active_connections[@]}"
        do
            CONNECTION_DICT[$connection]="Active"
        done
    fi
    return 0

}

activate_connection(){
    nmcli connection up "$SELECTED_CONNECTION" &> /dev/null &
    return 0
}

deactivate_connection(){
    nmcli connection down "$SELECTED_CONNECTION" &> /dev/null &
    return 0
}

main(){
    determine_connection_list

    if [[ $# -eq 0 ]]; then
        for connection in "${!CONNECTION_DICT[@]}"
        do
            echo "VPN connecitons - ${CONNECTION_DICT[$connection]}:${connection}"
        done
        return 0
    fi

    SELECTED_CONNECTION=$(echo "$@" | cut -d ':' -f2)
    if [[ ${CONNECTION_DICT[$SELECTED_CONNECTION]} == "Inactive" ]]; then
        activate_connection
    elif [[ ${CONNECTION_DICT[$SELECTED_CONNECTION]} == "Active" ]]; then
        deactivate_connection
    fi

    exit 0
}

main "$@"
