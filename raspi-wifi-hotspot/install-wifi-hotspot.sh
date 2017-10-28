#!/bin/bash

# upgrade raspi
cp files/source.list /etc/apt/source.list
apt-get update
apt-get -y dist-upgrade

apt-get -y install dnsmasq hostapd

systemctl stop dnsmasq
systemctl stop hostapd

cp files/dhcpcd.conf /etc/dhcpcd.conf
cp files/interfaces /etc/network/interfaces

service dhcpcd restart
sleep 90 | ifdown wlan0 && ifup wlan0
ifdown wlan0
ifup wlan0

cp files/dnsmasq.conf /etc/dnsmasq.conf
cp files/hostapd.conf /etc/hostapd/hostapd.conf

echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd

service hostapd start
service dnsmasq start 
