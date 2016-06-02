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
