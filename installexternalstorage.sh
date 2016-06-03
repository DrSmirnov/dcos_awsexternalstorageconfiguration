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
curl -L -o /home/core/resources/mesos-slave-common https://raw.githubusercontent.com/DrSmirnov/dcos_awsexternalstorageconfiguration/master/dvdi/mesos-slave-common

#Backup existing files for debugging purposes
mkdir /home/core/backup
cp /opt/mesosphere/etc/mesos-slave-modules.json /home/core/backup/mesos-slave-modules.json
cp /opt/mesosphere/etc/mesos-slave-common /home/core/backup/mesos-slave-common

#Apply neccesary changes to dcos configuration
sudo cp /home/core/resources/mesos-slave-modules.json /opt/mesosphere/etc/mesos-slave-modules.json
sudo cp /home/core/resources/mesos-slave-common /opt/mesosphere/etc/mesos-slave-common

#sed 's$MESOS_ISOLATION.*$MESOS_ISOLATION=cgroups/cpu,cgroups/mem,posix/disk,com_emccode_mesos_DockerVolumeDriverIsolator$' /opt/mesosphere/etc/mesos-slave-common | sudo tee /opt/mesosphere/etc/mesos-slave-common