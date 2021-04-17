#!/bin/sh

## UNINSTALL NOTICE #########################################

fmt -s -w $(tput cols) <<-EOF
        ==================================
        !! DESTRUCTIVE UNINSTALL NOTICE !!
        ==================================
        WARNING: This script will uninstall 
        
        Nagios 
        MySql
        Postgresql
        
        from this system as well as all data associated with these services.
        This action is irreversible and will result in the removal of
        all Nagios databases, configuration files, log files, and services.

EOF

read -p "Are you sure you want to continue? [y/N] " res

if [ "$res" = "y" -o "$res" = "Y" ]; then
        echo "Proceeding with uninstall..."
else
        echo "Uninstall cancelled"
        exit 1
fi

# Stop services
echo "Stopping services..."
service nagios stop
# service npcd stop
# service ndo2db stop

# Remove init.d files
echo "removing init files..."
rm -rf /etc/init.d/nagios

# Remove users and sudoers
echo "Removing users and suduoers..."
userdel -r nagios
groupdel nagcmd
rm -f /etc/sudoers.d/nagios

# Remove crontabs
echo "Removing crontabs..."
rm -f /etc/cron.d/nagios

# Remove various files
echo "Removing files..."
rm -rf /usr/local/nagios
# rm -rf /usr/local/nagios
# Remove NagiosQL files
# echo "Removing NagiosQL files..."
# rm -rf /etc/nagiosql
# rm -rf /var/www/html/nagiosql
# # rm -rf /var/lib/mysql
# rm -rf /var/lib/pgsql
# # Not going to do this as it may contain your only backup
# #rm -rf /store/backups
# # Remove Apache configs
echo "Removing Apache configs..."
rm -f /etc/httpd/conf.d/nagios.conf
# rm -f /etc/httpd/conf.d/nagiosql.conf
# rm -f /etc/httpd/conf.d/nrdp.conf
# rm -f /usr/local/nrdp/nrdp.conf
service httpd restart
# Remove xinetd configs
# echo "Removing xinetd configs..."
# rm -f /etc/xinetd.d/nrpe
# rm -f /etc/xinetd.d/nsca
# rm -f /etc/xinetd.d/nrdp
# service xinetd restart
# Remove Postgres databases
# echo "Removing Postgres and mysql databases..."
# yum remove mysql postgresql -y
# Remove DB backup scripts
# echo "Removing database backup scripts..."
# rm -f /root/scripts/automysqlbackup
# rm -f /root/scripts/autopostgresqlbackup
# cd /tmp
# rm -rf nagios xi*.tar.gz
# echo "Preparing to reinstall"
# cd /tmp
# echo "Downloading latest stable version installer"
# wget http://assets.nagios.com/downloads/nagios/xi-latest.tar.gz
# # Begin installation
# echo "Begining installation! Enjoy the ride!"
# tar xzf xi-latest.tar.gz
# (
# cd /tmp/nagios
# ./fullinstall
# )


fmt -s -w $(tput cols) <<-EOF
        ====================
       All SET! Go in peace!
        ====================

EOF


