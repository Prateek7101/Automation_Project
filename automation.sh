#!/bin/bash

#TASK 2 

timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket_name="upgrad-prateek"
myname="prateek"

############Step 1: Update the package ###############

sudo apt update -y

########Step 2: Install the apache2 package if it is not already installed ########

if [ 'dpkg -l apache2 | grep apache2 | wc -l' == 1 ]
then
        echo "Apache2 is already installed"
else
        echo "Installing Apache2"
        sudo apt install apache2 -y
fi

############Step 3: Ensure that the apache2 service is running############

if [ 'systemctl status apache2 | grep running | wc -l' == 1 ]
then
        echo "Apache2 is already running"
else
        echo "Start Apache2"
        sudo systemctl start apache2
fi

##############Step 4: Enasure that the apache2 service is enabled##############

if [ 'systemctl status apache2 | grep enabled | wc -l' == 1 ]
then
        echo "Apache2 is already enabled"
else
        echo "Enable Apache2"
        sudo systemctl enable apache2
fi

############Step 5:Create a tar archive of apache2 access logs and error logs#############

echo "Compressing the logs and storing it into /tmp"

cd /var/log/apache2/
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

#############Step 6:Copy the archive to s3 bucket#############

echo "Copying  the logs to s3 Bucket"

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket_name}/${myname}-httpd-logs-${timestamp}.tar

#TASK 3

##################################Step 1:Bookkeeping######################################
if [ -e /var/www/html/inventory.html ]
then
        echo "Inventory does exists"
else
        touch /var/www/html/inventory.html
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> /var/www/html/inventory.html
fi

echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; `du -h /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}'`" >> /var/www/html/inventory.html

############################Step 2: Cron Job################################################
if [ -e /etc/cron.d/automation ]
then
        echo "Cron job exists"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job added"
fi
