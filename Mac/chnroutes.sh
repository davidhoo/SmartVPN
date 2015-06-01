#!/bin/bash

echo "update ip-up"
cat >ip-up <<EOF
#!/bin/bash
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"
OLDGW=`netstat -nr | grep '^default' | grep -v 'ppp' | sed 's/default *\([0-9\.]*\) .*/\1/'`

if [ ! -e /tmp/pptp_oldgw ]; then
    echo "${OLDGW}" > /tmp/pptp_oldgw
fi

dscacheutil -flushcache
source /etc/ppp/chnroutes-up

# 根据指定wifi，添加特定路由。适用于渣浪这种，很多内网ip的情况,有需要自己打开下面注释，根据自己情况修改sina-up
# currentwifi=`networksetup -getairportnetwork 'en0'`
# if [[ ${currentwifi/sina//} != $currentwifi ]]
# then
#     source /etc/ppp/sina-up
# fi
EOF

echo "update ip-down"
cat >ip-down <<EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

if [ ! -e /tmp/pptp_oldgw ]; then
        exit 0
fi

source /etc/ppp/chnroutes-down

# 根据指定wifi，添加特定路由。适用于渣浪这种，很多内网ip的情况,有需要自己打开下面注释，根据自己情况修改sina-down
currentwifi=`networksetup -getairportnetwork 'en0'`
if [[ ${currentwifi/sina//} != $currentwifi ]]
then
    source /etc/ppp/sina-down
fi

rm /tmp/pptp_oldgw
EOF

echo "update china ip list"
ips=`curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep 'apnic|CN|ipv4' | cut -d \| -f 4,5`

echo 'OLDGW=`cat /tmp/pptp_oldgw`' > chnroutes-up
echo 'OLDGW=`cat /tmp/pptp_oldgw`' > chnroutes-down

ipindex=0
for iplist in $ips
do
    let ipindex=$ipindex+1
    if [ $[ $ipindex % 100 ] = 0 ];
    then
        printf .
    fi
    echo $iplist | awk -F \| '{printf("route add %s/%s $\{OLDGW\}\n", $1, 32-(log($2)/log(2)))}' >> chnroutes-up
    echo $iplist | awk -F \| '{printf("route delete %s/%s $\{OLDGW\}\n", $1, 32-(log($2)/log(2)))}' >> chnroutes-down
done
echo "done"
