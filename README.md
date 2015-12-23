# SmartVPN
智能上网，根据IP、域名，智能路由。只有需要梯子的情况，才会走VPN流量

基于chnroutes、dnsmasq、gfwlist 修改而来。目前只做了Mac下通过VPN智能翻墙。未来计划添加小米路由器版。

```sh
$ cd Mac
$ ./chnroutes.sh

$ sudo cp chnroutes-* ip-* sina-* /etc/ppp
$ sudo chmod +x /etc/ppp/*
```
