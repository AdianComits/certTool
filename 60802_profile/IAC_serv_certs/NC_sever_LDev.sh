#!/bin/sh
OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF



# sever  End Entity certificate: create request first let est signs it 
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key1_serv.key

 CN="10.10.10.2" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key1_serv.key -out ee_LDevID_req1_serv.pem

 $OPENSSL ec -in ee_LDevID_key1_serv.key -pubout >server_pub_key1.pub
