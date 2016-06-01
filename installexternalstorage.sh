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