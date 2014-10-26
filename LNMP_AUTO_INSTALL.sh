#/bin/bash

#系统基本属性配置
echo "====即将对系统基本属性进行修改===="
sleep 1
echo "====Loading......===="

sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux

sed -i "s/SELINUXTYPE=targeted//g" /etc/sysconfig/selinux

service iptables stop

chkconfig iptables off

#修改系统支持文件数量
cat >>/etc/security/limits.conf<<eof
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
eof

sleep 2
echo "====基本属性修改完成===="


#安装Nginx
echo "====即将安装Nginx===="
sleep 1
echo "====Loading......===="

yum remove httpd* php*

rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

yum -y install nginx

chkconfig nginx on

service nginx start

sleep 2
echo "====Nginx安装完成===="

#安装PHP
echo "====即将安装PHP及相关组件===="
sleep 1
echo "====Loading......===="

echo 'exclude=*.5.4.*' >> /etc/yum.conf

yum -y install php php-fpm

yum -y install php-mysql php-xml php-gd php-mbstring php-cli php-soap

chkconfig php-fpm on

service php-fpm start

sleep 2
echo "====PHP及相关组件安装完成===="

#配置Nginx配置文件(需要手工输入,无法完成自动替换)
echo "====即将对Nginx及PHP进行相关基础配置===="
sleep 1
echo "====Loading......===="

\cp default.conf /etc/nginx/conf.d/default.conf

#配置PHP-FPM
sed -i "s/apache/nginx/g" /etc/php-fpm.d/www.conf

mkdir /var/www/content

chown nginx.nginx /var/www/content -R

chown 777 /var/lib/php/session

service nginx restart

service php-fpm restart

sleep 2
echo "====Nginx及PHP相关基础配置完成===="

#创建测试文件
echo "====即将创建测试页面===="
sleep 1
echo "====Loading......===="

touch /var/www/content/info.php

echo '<?php phpinfo();' >> /var/www/content/info.php

sleep 2
echo "====测试页面创建完成,请访问http://hostname(localhost)/info.php===="

echo "====Nginx相关命令(service nginx start|stop|restart|status)===="
echo "====Nginx配置文件(/etc/nginx/conf.d/default.conf)===="
echo "====WEB根目录(/var/www/content)===="
echo "====PHP-FPM相关命令(service php-fpm start|stop|restart|status)===="
echo "====PHP-FPM配置文件(/etc/php-fpm.d/www.conf)===="
echo "====请详细阅读redeme.html文件===="