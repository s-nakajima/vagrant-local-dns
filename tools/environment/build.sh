#!/bin/bash

ALLYES="true"; export ALLYES

header() {
	echo " "
	echo "----------------------------------"
	echo "$1"
	echo "----------------------------------"
}
execute() {
	echo "root@local-dns]# $1"
	if [ "$2" = "" ]; then
		$1
		echo " "
	fi
}

echo " "
echo "###############################"
echo "# Virtual box install started #"
echo "###############################"
echo " "


header "OS Update"
	execute "apt -y dist-upgrade"
	execute "cat /etc/os-release"

	# langpacks-jaのインストール
	execute "apt install -y language-pack-ja-base language-pack-ja"
	execute "update-locale LANG=ja_JP.UTF-8"
	execute "cat /etc/default/locale"
	
	# timezoneの設定
	execute "timedatectl set-timezone Asia/Tokyo"
	execute "timedatectl status"

	execute "mv -n /root/.bashrc /root/.bashrc.dist"
	execute "cp -pf /var/www/vagrant/environment/root_bashrc /root/.bashrc"

	execute "mv -n /home/vagrant/.bashrc /home/vagrant/.bashrc.dist"
	execute "cp -pf /var/www/vagrant/environment/vagrant_bashrc /home/vagrant/.bashrc"
	execute "apt-get -y update"


header "Install Chrony(NTP.v4)"
	execute "apt -y install chrony"
	execute "mv -n /etc/chrony/chrony.conf /etc/chrony/chrony.conf.dist"
	execute "cp /var/www/vagrant/environment/chrony/chrony.conf /etc/chrony/"
	execute "systemctl restart chrony"
	execute "systemctl disable chronyd.service"
	execute "systemctl enable chrony.service"
	execute "systemctl is-enabled chrony.service"
	execute "chronyc sources"


header "Install dnsmasq"
	execute "apt-get -y install dnsmasq"
	execute "cp /var/www/vagrant/environment/dnsmasq/local.conf /etc/dnsmasq.d/"


header "Install finish"
	execute "touch /home/vagrant/.build_finish"
	execute "chown vagrant:vagrant /home/vagrant/.build_finish"


echo " "
echo "#########################"
echo "# Virtual box installed #"
echo "#########################"
echo " "
