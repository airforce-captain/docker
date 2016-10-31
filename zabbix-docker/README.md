###关于本镜像

zabbix官方的server镜像报警脚本位置是错误的，也不修正.懒得提交issue.
原issue:
官方image则是: /usr/share/zabbix/alertscripts/

正确的报警脚本路径是: /usr/lib/zabbix/alertscripts/

解决办法:
1. 修改zabbix编译参数.
2. 增加一个链接指向: ln -s /usr/lib/zabbix /usr/share/zabbix


除了修正此问题之外,计划新增:
1. postfix 队列监控.
