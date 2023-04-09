#!/bin/sh
OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF



# sever  End Entity certificate: create request first let est signs it 
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_demo.key

 CN="10.10.10.10" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key_demo.key -out ee_LDevID_csr_serv_demo.pem

 $OPENSSL ec -in ee_LDevID_key_demo.key -pubout >ee_LDevID_key_demo.pub
