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
