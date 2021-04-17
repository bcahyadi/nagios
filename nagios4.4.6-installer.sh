#!/bin/sh
echo "███╗   ██╗ █████╗  ██████╗ ██╗ ██████╗ ███████╗    ██╗  ██╗██╗  ██╗    ██████╗               "
echo "████╗  ██║██╔══██╗██╔════╝ ██║██╔═══██╗██╔════╝    ██║  ██║██║  ██║   ██╔════╝               "
echo "██╔██╗ ██║███████║██║  ███╗██║██║   ██║███████╗    ███████║███████║   ███████╗               "
echo "██║╚██╗██║██╔══██║██║   ██║██║██║   ██║╚════██║    ╚════██║╚════██║   ██╔═══██╗              "
echo "██║ ╚████║██║  ██║╚██████╔╝██║╚██████╔╝███████║         ██║██╗  ██║██╗╚██████╔╝              "
echo "╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝ ╚══════╝         ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝               "
echo "                                                                                             "
echo "██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗"
echo "██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║"
echo "██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║"
echo "██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║"
echo "██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║"
echo "╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
                                                                                             
echo " "
read -p "Press any key to continue or ctrl-C to abort..."

useradd nagios
passwd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagcmd apache
cd /opt
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
tar xzf nagios-4.4.6.tar.gz
cd nagios-4.4.6
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-daemoninit
make install-config
make install-commandmode
make install-exfoliation
make install-webconf
htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin 4dm1nNAGIOS
service httpd restart
cd /opt
wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar xzf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install


# upgrade cURL
echo"download curl installer"
cd /opt
rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/rhel6/x86_64/city-fan.org-release-2-1.rhel6.noarch.rpm
sed -i 's|enabled=1|enabled=0|' /etc/yum.repos.d/city-fan.org.repo
yum --enablerepo=city-fan.org update curl -y

echo "Checking Nagios Config"
echo "make sure no warning or no error"
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
service nagios start

chkconfig --add nagios
chkconfig --level 35 nagios on