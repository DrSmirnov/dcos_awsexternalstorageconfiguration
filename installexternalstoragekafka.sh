#!/bin/sh

cd /home/core

#install rexray
/usr/bin/curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -s stable

#set rexray configuration
/usr/bin/curl https://raw.githubusercontent.com/DrSmirnov/dcos_awsexternalstorageconfiguration/master/rexray/config.yml | sudo tee /etc/rexray/config.yml

#starting rexray service
sudo rexray start

#install the dvdcli
/usr/bin/curl -sSL https://dl.bintray.com/emccode/dvdcli/install | sh -s stable

#Download the DVDI mesos binaries
mkdir /home/core/dvdi
curl -L -o /home/core/dvdi/libmesos_dvdi_isolator-0.28.1.so https://github.com/emccode/mesos-module-dvdi/releases/download/v0.4.2/libmesos_dvdi_isolator-0.28.1.so

#Preparing neccesary resource files 
mkdir /home/core/resources
curl -L -o /home/core/resources/mesos-slave-modules.json https://raw.githubusercontent.com/DrSmirnov/dcos_awsexternalstorageconfiguration/master/dvdi/mesos-slave-modules.json
curl -L -o /home/core/resources/mesos-slave-common-kafka https://raw.githubusercontent.com/DrSmirnov/dcos_awsexternalstorageconfiguration/master/dvdi/mesos-slave-common-kafka

#Backup existing files for debugging purposes
mkdir /home/core/backup
cp /opt/mesosphere/etc/mesos-slave-modules.json /home/core/backup/mesos-slave-modules.json
cp /opt/mesosphere/etc/mesos-slave-common /home/core/backup/mesos-slave-common
cp /opt/mesosphere/etc/mesos-slave-public /home/core/backup/mesos-slave-public

#Apply neccesary changes to dcos configuration
sudo cp /home/core/resources/mesos-slave-modules.json /opt/mesosphere/etc/mesos-slave-modules.json
sudo cp /home/core/resources/mesos-slave-common-kafka /opt/mesosphere/etc/mesos-slave-common
sudo cp /home/core/resources/mesos-slave-common-public /opt/mesosphere/etc/mesos-slave-public

#apply additional kafka attribute to the kafka nodes
echo "MESOS_ATTRIBUTES=usage:kafka;public_ip:true" | sudo tee -a /opt/mesosphere/etc/mesos-slave-public

#restart dcos slave service to activete the changes
mkdir /home/core/log
sudo systemctl reload-or-restart dcos-mesos-slave-public.service > /home/core/log/restart_public_slave.log

#sed 's$MESOS_ATTRIBUTES.*$MESOS_ATTRIBUTES=usage:kafka;public_ip:true$' /opt/mesosphere/etc/mesos-slave-public | sudo tee /opt/mesosphere/etc/mesos-slave-public