#!/bin/bash

# 在 nat 表中创建新链
iptables -t nat -N SHADOWSOCKS

# 发往shadowsocks服务器的数据不走代理，否则陷入死循环
iptables -t nat -A SHADOWSOCKS -d 122.9.62.32 -j RETURN

# 保留地址、私有地址、回环地址 不走代理
iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

# 其余的全部重定向至ss-redir监听端口1080(端口号随意,统一就行)
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080

# OUTPUT链添加一条规则，重定向至shadowsocks链
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
iptables -t nat -I PREROUTING -p tcp -j SHADOWSOCKS
