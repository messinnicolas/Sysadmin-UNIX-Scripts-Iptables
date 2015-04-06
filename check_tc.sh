#!/bin/bash

/etc/init.d/openvpn status

if [ $? -eq 1 ]
	then
	/etc/init.d/openvpn start 
fi

/etc/init.d/openvpn status
