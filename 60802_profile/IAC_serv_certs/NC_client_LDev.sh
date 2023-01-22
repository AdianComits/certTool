#!/bin/sh

OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF



# TruststoreAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ts_admin.key

 CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_ts_admin.key -out ee_LDevID_req_cli_ts_admin.pem



# KeystoreAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ks_admin.key

 CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_ks_admin.key -out ee_LDevID_req_cli_ks_admin.pem


# UserMappingAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_um_admin.key

 CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_um_admin.key -out ee_LDevID_req_cli_um_admin.pem

 




