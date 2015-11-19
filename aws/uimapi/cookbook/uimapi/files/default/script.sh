#!/bin/sh

sed -i "s/temp-server-name/$(sed 's:/:\\/:g' /etc/hostname)/" /home/ubuntu/virtualhost-template
hostname -I > /tmp/ipaddress
sed -i "s/temp-ip-address/$(sed 's:/:\\/:g' /tmp/ipaddress)/" /home/ubuntu/virtualhost-template
cat /home/ubuntu/virtualhost-template >> /etc/apache2/apache2.conf
mkfs -text4 /dev/xvdb
tune2fs -o user_xattr,acl /dev/xvdb
mkdir -p /cust/logs
mount /dev/xvdb /cust/logs
echo "/dev/xvdb /cust/logs ext4 noatime,noexec,nodiratime 0 0" >> /etc/fstab
rm -rf /var/log/apache2
ln -s /cust/logs /var/log/apache2
cd /etc/apache2
echo "AddHandler application/x-httpd-php .php" >> mods-available/php5.load
a2enmod php5
ln -s /cust/logs
cd /etc/apache2/mods-enabled
ln -s ../mods-available/expires.load
ln -s ../mods-available/rewrite.load

rm -f /etc/rc2.d/S99script.sh

