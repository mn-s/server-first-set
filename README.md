# server-first-set
for new centos server
本脚本仅用于centos

折腾vps的时候免不了经常重装系统，每次重装系统都要重复进行一些基本设置，很麻烦。所以写了这个脚本。
这个脚本做了什么：
1.新增一个普通用户，并设置这个用户的密码
2.根据输入的字符修改root密码（没有输入任何字符则不修改）。
3.更新系统，并安装常用软件包：screen zip unzip sendmail lrzsz(可通过xshell客户端直接上传下载文件)
4.关闭selinux
5.修改ssh端口，禁止root登陆ssh。所以一定要记住你新建的用户名和密码。
6.iptables开放新的ssh端口
