#!/bin/sh

# Install ambari-server
yum -y install ambari-server

# bootstrap ambari-server
ambari-server setup -s --java-home=/usr/lib/jvm/jre/

# disable ssl checks
sed -i 's/verify=platform_default/verify=disable/' /etc/python/cert-verification.cfg || echo "could not disable ssl checks"

# start ambari-server
ambari-server start