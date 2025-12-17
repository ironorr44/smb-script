#!/usr/bin/bash

#Collect information to set variables
echo "Enter the IP Address or Hostname of the NAS:"
read hostname
echo "Enter the Share that you want to mount:"
read share
echo "Enter the Username for the NAS:"
read username
echo "Enter the Password for the NAS:"
read password


#Display the values for the variables that were set
echo ""
echo "*****************************************************************"
echo " The following details will be used to configure the CIFS share: "
echo ""
echo "    Hostname:" $hostname
echo "    Share:   " $share
echo "    Username:" $username
echo "    Password:" $password
echo "*****************************************************************"
echo ""


#Give option to exit script if values are incorrect
echo "Enter [yes] to continue, or enter anything else to exit script:"
read answer01
case $answer01 in
	"yes")
		echo "-------------------------------------------------"
		echo "--Installing cifs-utils and autofs if necessary--"
		echo "-------------------------------------------------"
		;;
	*)
		echo "*********************************"
		echo "!!! SCRIPT HAS BEEN CANCELLED !!!"
		echo "*********************************"
		echo ""
		exit 1
		;;
esac


#Install cifs-utils and autofs
sudo apt -y install cifs-utils && sudo apt -y install autofs


#Create mount point
echo "------------------------"
echo "--Creating mount point--"
echo "------------------------"
sudo mkdir /mnt/cifs


#Create credential file, set user/pass, and set permissions
echo "----------------------------"
echo "--Creating credential file--"
echo "----------------------------"
sudo mkdir /etc/.credentials
sudo touch /etc/.credentials/$share
echo "username="$username | sudo tee -a /etc/.credentials/$share
echo "password="$password | sudo tee -a /etc/.credentials/$share
sudo chown root /etc/.credentials/$share
sudo chmod 600 /etc/.credentials/$share


#Configure auto.master, create/configure auto.smb.shares
echo "-----------------------------------------------"
echo "--Configuring auto.master and auto.smb.shares--"
echo "-----------------------------------------------"
echo "/mnt/cifs /etc/auto.smb.shares --timeout 15 browse" | sudo tee -a /etc/auto.master
sudo touch /etc/auto.smb.shares
echo $share" -fstype=cifs,rw,credentials=/etc/.credentials/"$share",noperm ://"$hostname"/"$share | sudo tee -a /etc/auto.smb.shares


#Restart autofs
echo "-----------------------------"
echo "--Restarting autofs service--"
echo "-----------------------------"
sudo systemctl restart autofs


#Announce completion of setup and provide path to share
echo "**************************************************"
echo "***************   SETUP COMPLETE   ***************"
echo "**************************************************"
echo ""
echo "CIFS share is at /mnt/cifs/"$share
echo ""
