#!/bin/bash

### This script assumes that you have an up to date debian etch with a working bat0 interface.

### SYSTEM (debian etch) ###

apt update
apt install nodejs npm ruby-sass prometheus grafana nginx

### HOPGLASS (copy paste from hopglass(-server) doku on github) ####

#Create a user
useradd -mU hopglass
su - hopglass

#Clone and install dependencies
git clone https://github.com/plumpudding/hopglass-server
cd hopglass-server
npm install
cd
git clone https://github.com/plumpudding/hopglass
cd hopglass
npm install
npm install grunt-cli
node_modules/.bin/grunt

exit

cp hopglass/config.json /home/hopglass/hopglass/build/
# this step assumes that you have a bat0 interface
cp hopglass-server/*.json /home/hopglass/hopglass-server/
cp hopglass-server/hopglass.service /etc/systemd/system/
systemctl enable hopglass
systemctl start hopglass

#### GRAFANA & PROMETHEUS ####

cp grafana/grafana.ini /etc/grafana/
systemctl enable grafana-server
systemctl start grafana-server

cp prometheus/prometheus /etc/default/
cp prometheus/prometheus.yml /etc/prometheus/
systemctl enable prometheus
systemctl start prometheus

cp nginx/default /etc/nginx/sites-available/
systemctl reload nginx

# now add http://localhost:9090/ as default prometheus datasource in the grafana webinterface under http://<host>/grafana
# add the grafana dashboards under grafana/







