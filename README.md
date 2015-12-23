# SmartVPN
智能上网，根据IP、域名，智能路由。只有需要梯子的情况，才会走VPN流量

基于chnroutes、dnsmasq、gfwlist 修改而来。目前只做了Mac下通过VPN智能翻墙。未来计划添加小米路由器版。

china-ip-list 基于高春辉的数据<https://github.com/17mon/china_ip_list>

```sh
git clone git@github.com:davidhoo/SmartVPN.git
$ cd SmartVPN/Mac
$ ./chnroutes.sh

$ sudo cp chnroutes-* ip-* sina-* /etc/ppp
$ sudo chmod +x /etc/ppp/*
```
