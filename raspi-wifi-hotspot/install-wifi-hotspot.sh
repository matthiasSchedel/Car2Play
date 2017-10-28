#!/bin/bash


sudo su

# upgrade raspi
cp files/sources.list /etc/apt/sources.list
apt-get update
apt-get dist-upgrade

apt-get install dnsmasq hostapd

systemctl stop dnsmasq
systemctl stop hostapd

cp files/dhcpcd.conf /etc/dhcpcd.conf
cp files/interfaces /etc/network/interfaces

service dhcpcd restart
ifdown wlan0
ifup wlan0

cp files/dnsmasq.conf /etc/dnsmasq.conf
cp files/hostapd.conf /etc/hostapd/hostapd.conf

echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf" >> /etc/default/hostapd

service hostapd start
service dnsmasq start 
