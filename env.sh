#!/bin/bash

#export HAPROXY_IP=$(hostname -i)
export HAPROXY_IP=172.20.0.5
export OC_IP=172.20.0.6
export CLIENT1_IP=172.20.0.7
export CLIENT2_IP=172.20.0.8
export BROWSER_IP=172.20.0.9

#export CLIENT1_URL=


export DOCKER_IMAGE_OC=cloudbees/cloudbees-core-oc:2.426.3.3
export DOCKER_IMAGE_CLIENT=cloudbees/cloudbees-core-cm:2.426.3.3
export OC_URL=oc.ha
export CLIENTS_URL=client.ha

# Paths on host for mapped volumes
export OC_PERSISTENCE=/tmp/jenkins_ha
export CONTROLLER_PERSISTENCE=/tmp/jenkins_ha_controller1
export CONTROLLER1_CACHES=/tmp/jenkins_ha_controller1_caches
export CONTROLLER2_CACHES=/tmp/jenkins_ha_controller2_caches
