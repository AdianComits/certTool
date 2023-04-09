#!/bin/sh

OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF



# TruststoreAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_rs_admin.key

 CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_rs_admin.key -out ee_LDevID_req_cli_rs_admin.pem


 




