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
groupadd nagcmd
usermod -a -G nagcmd nagios
cd /opt
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
tar xzf nagios-4.4.6.tar.gz
cd nagios-4.4.6
./configure --with-command-group=nagcmd
make all
sudo make install
sudo make install-commandmode
sudo make install-init
sudo make install-config
sudo make install-webconf

usermod -G nagcmd apache



cd /opt
wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
tar xzf nagios-plugins-2.2.1.tar.gz
cd nagios-plugins-2.2.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install

#install nrpe
wget https://sourceforge.net/projects/nagios/files/nrpe-4.x/nrpe-4.0.3/nrpe-4.0.3.tar.gz
tar xvf nrpe-*.tar.gz
cd nrpe-*
./configure --enable-command-args --with-nagios-user=nagios --with-nagios-group=nagios --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu
make all
sudo make install
sudo make install-xinetd
sudo make install-daemon-config
service nrpe restart

# upgrade cURL
echo"download curl installer"
cd /opt
rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/rhel6/x86_64/city-fan.org-release-2-1.rhel6.noarch.rpm
sed -i 's|enabled=1|enabled=0|' /etc/yum.repos.d/city-fan.org.repo
yum --enablerepo=city-fan.org update curl -y

echo "Checking Nagios Config"
echo "make sure no warning or no error"
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

htpasswd -c -b /usr/local/nagios/etc/htpasswd.users nagiosadmin 4dm1nNAGIOS
service daemon-reload
service httpd restart
service nagios start

chkconfig --add nagios
chkconfig --level 35 nagios on
