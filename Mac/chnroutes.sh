#!/bin/sh

echo "update ip-up"
cat >ip-up <<EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

echo "ip-up beging ..." > /tmp/ppp.log
chmod +r /tmp/ppp.log
echo \$# parameters is: \$@ >> /tmp/ppp.log

dscacheutil -flushcache

exec 1>&-
exec 2>&-

(sh /etc/ppp/chnroutes-up \$6) &

# 根据指定wifi，添加特定路由。适用于渣浪这种，很多内网ip的情况,有需要自己打开下面注释，根据自己情况修改sina-up
# currentwifi=\`networksetup -getairportnetwork 'en0'\`
# if [[ \${currentwifi/sina//} != \$currentwifi ]]
# then
#     (sh /etc/ppp/sina-up \$6) &
# fi
EOF

echo "update ip-down"
cat >ip-down <<EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

echo "ip-down beging ..." >> /tmp/ppp.log
echo \$# parameters is: \$@ >> /tmp/ppp.log

exec 1>&-
exec 2>&-

(sh /etc/ppp/chnroutes-down \$6) &

currentwifi=\`networksetup -getairportnetwork 'en0'\`
if [[ \${currentwifi/sina//} != \$currentwifi ]]
then
    (sh /etc/ppp/sina-down \$6) &
fi
EOF

echo "update china ip list ..."
ips=`curl -s 'https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt'`

cat >chnroutes-up <<EOF
#!/bin/sh

echo "chnroutes-up beging ..." >> /tmp/ppp.log
echo \$# parameters is: \$@ >> /tmp/ppp.log
EOF

cat >chnroutes-down <<EOF
#!/bin/sh

echo "chnroutes-down beging ..." >> /tmp/ppp.log
echo \$# parameters is: \$@ >> /tmp/ppp.log
EOF

ipindex=0
for ip in $ips
do
    let ipindex=$ipindex+1
    if [ $[ $ipindex % 100 ] = 0 ];
    then
        printf .
    fi
    echo route add $ip \$1 >> chnroutes-up
    echo route delete $ip \$1 >> chnroutes-down
done
echo "\ndone"
