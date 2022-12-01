#!/bin/sh


OPENSSL=/home/adian/workspace_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/workspace_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF

 
 $OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_san_key_cli.key

 CN="adiancli" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext_OID.cnf \
	-new -sha384  -key ee_LDevID_san_key_cli.key -out ee_LDevID_san_req_cli.pem

 #Sign request: end entity extensions
URINAME=$subAltName $OPENSSL  x509   -req -in ee_LDevID_san_req_cli.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext_OID.cnf -extensions usr_cert   -out ee_LDevID_san_client.crt
