#/bin/bash

#ϵͳ������������
echo "====������ϵͳ�������Խ����޸�===="
sleep 1
echo "====Loading......===="

sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux

sed -i "s/SELINUXTYPE=targeted//g" /etc/sysconfig/selinux

service iptables stop

chkconfig iptables off

#�޸�ϵͳ֧���ļ�����
cat >>/etc/security/limits.conf<<eof
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
eof

sleep 2
echo "====���������޸����===="


#��װNginx
echo "====������װNginx===="
sleep 1
echo "====Loading......===="

yum remove httpd* php*

rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

yum -y install nginx

chkconfig nginx on

service nginx start

sleep 2
echo "====Nginx��װ���===="

#��װPHP
echo "====������װPHP��������===="
sleep 1
echo "====Loading......===="

echo 'exclude=*.5.4.*' >> /etc/yum.conf

yum -y install php php-fpm

yum -y install php-mysql php-xml php-gd php-mbstring php-cli php-soap

chkconfig php-fpm on

service php-fpm start

sleep 2
echo "====PHP����������װ���===="

#����Nginx�����ļ�(��Ҫ�ֹ�����,�޷�����Զ��滻)
echo "====������Nginx��PHP������ػ�������===="
sleep 1
echo "====Loading......===="

\cp default.conf /etc/nginx/conf.d/default.conf

#����PHP-FPM
sed -i "s/apache/nginx/g" /etc/php-fpm.d/www.conf

mkdir /var/www/content

chown nginx.nginx /var/www/content -R

chown 777 /var/lib/php/session

service nginx restart

service php-fpm restart

sleep 2
echo "====Nginx��PHP��ػ����������===="

#���������ļ�
echo "====������������ҳ��===="
sleep 1
echo "====Loading......===="

touch /var/www/content/info.php

echo '<?php phpinfo();' >> /var/www/content/info.php

sleep 2
echo "====����ҳ�洴�����,�����http://hostname(localhost)/info.php===="

echo "====Nginx�������(service nginx start|stop|restart|status)===="
echo "====Nginx�����ļ�(/etc/nginx/conf.d/default.conf)===="
echo "====WEB��Ŀ¼(/var/www/content)===="
echo "====PHP-FPM�������(service php-fpm start|stop|restart|status)===="
echo "====PHP-FPM�����ļ�(/etc/php-fpm.d/www.conf)===="
echo "====����ϸ�Ķ�redeme.html�ļ�===="