#!/bin/sh

cd /home/core

#Backup existing files for debugging purposes
mkdir /home/core/backup
cp /opt/mesosphere/etc/mesos-slave-modules.json /home/core/backup/mesos-slave-modules.json
cp /opt/mesosphere/etc/mesos-slave-common /home/core/backup/mesos-slave-common

#Apply neccesary changes to dcos configuration
sudo cp /home/core/resources/mesos-slave-modules.json /opt/mesosphere/etc/mesos-slave-modules.json
sed 's|MESOS_ISOLATION.*|MESOS_ISOLATION=cgroups/cpu,cgroups/mem,posix/disk,com_emccode_mesos_DockerVolumeDriverIsolator|' /opt/mesosphere/etc/mesos-slave-common | sudo tee /opt/mesosphere/etc/mesos-slave-common
