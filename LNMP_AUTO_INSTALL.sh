#/bin/bash
#系统基本属性配置
echo "====即将对系统基本属性进行修改===="
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=targeted//g" /etc/selinux/config
service iptables stop
chkconfig iptables off
#修改系统支持文件数量
cat >>/etc/security/limits.conf<<eof
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
eof
echo "====基本属性修改完成===="
#安装Nginx
echo "====即将安装Nginx===="
yum -y remove httpd* php*
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum -y install nginx
chkconfig nginx on
service nginx start
echo "====Nginx安装完成===="
#安装PHP
echo "====即将安装PHP及相关组件===="
echo 'exclude=*.5.4.*' >> /etc/yum.conf
yum -y install php php-fpm
yum -y install php-mysql php-xml php-gd php-mbstring php-cli php-soap
chkconfig php-fpm on
service php-fpm start
echo "====PHP及相关组件安装完成===="
#配置Nginx配置文件(需要手工输入,无法完成自动替换)
echo "====即将对Nginx及PHP进行相关基础配置===="
\cp default.conf /etc/nginx/conf.d/default.conf
#配置PHP-FPM
sed -i "s/apache/nginx/g" /etc/php-fpm.d/www.conf
mkdir /var/www/content
chown nginx.nginx /var/www/content -R
chown 777 /var/lib/php/session
service nginx restart
service php-fpm restart
echo "====Nginx及PHP相关基础配置完成===="
#创建测试文件
echo "====即将创建测试页面===="
touch /var/www/content/info.php
echo '<?php phpinfo();' >> /var/www/content/info.php
#重启服务器选择
echo "服务安装完成,需要重启系统[y,n]:"
read a
if [ $a = y ] ; then
echo '服务器正在重启...'
reboot
else
echo '部分服务将在手动重启后生效...'
fi
