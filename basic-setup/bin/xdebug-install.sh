#!/bin/bash
source .env
MASTERCONTAINER="${PREFIX_CONTAINER}horde_web"

CMD="zypper -n install php7-xdebug"
docker exec -i "$MASTERCONTAINER" bash -c "$CMD" 
echo "installing php7-xdebug"

CMD="rpm -qa '*xdebug*' --qf "%{VERSION}\n" | cut -d'.' -f1"
xdebug_major_version=$(docker exec -i "$MASTERCONTAINER" bash -c "$CMD")
echo "xdebug major version is: $xdebug_major_version"
    if [[ $xdebug_major_version -eq 2 ]]; then
        # configuration for Xdebug 2.9.5 as distributed by openSUSE Leap 15.3
        CMD='{
            echo "xdebug.remote_enable = 1";
            echo "xdebug.remote_autostart = 1";
            echo "xdebug.remote_port = 9000";
        } >> /etc/php7/conf.d/xdebug.ini';
        docker exec -i "$MASTERCONTAINER" bash -c "$CMD"
    elif [[ $xdebug_major_version -eq 3 ]]; then
        # NOTE: untested as of 2022-03-04, as only Tumbleweed has Xdebug 3
        CMD='{
            echo "xdebug.mode = develop,debug";
            echo "xdebug.start_with_request = yes";
        } >> /etc/php7/conf.d/xdebug.ini'
        docker exec -i "$MASTERCONTAINER" bash -c "$CMD"
    fi
    unset xdebug_major_version
