#!/bin/sh

OPENSSL=/home/adian/working_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/working_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF





# sever  End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key1_serv.key

 CN="10.10.10.2" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key1_serv.key -out ee_LDevID_req1_serv.pem

 #Sign request: end entity extensions
$OPENSSL  x509   -startdate 19900101000000Z -enddate 99991231235959Z  -req -in ee_LDevID_req1_serv.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert_server   -out ee_LDevID1_server.crt

$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key2_serv.key

ON="Device Manufacturer 1" $OPENSSL req -config ca2_ext.cnf\
	-new -sha384  -key ee_LDevID_key2_serv.key -out ee_LDevID_req2_serv.pem

 #Sign request: end entity extensions
$OPENSSL  x509  -startdate 19900101000000Z -enddate 99991231235959Z  -req -in ee_LDevID_req2_serv.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca2_ext.cnf -extensions usr_cert_san_server   -out ee_LDevID2_server.crt

$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key3_serv.key

 CN="10.10.10.1" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key3_serv.key -out ee_LDevID_req3_serv.pem

 #Sign request: end entity extensions
$OPENSSL  x509  -startdate 19900101000000Z -enddate 99991231235959Z  -req -in ee_LDevID_req3_serv.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert_san_server   -out ee_LDevID3_server.crt



$OPENSSL ec -in ee_LDevID_key1_serv.key -pubout >server_pub_key1.pub
$OPENSSL ec -in ee_LDevID_key2_serv.key -pubout >server_pub_key2.pub
$OPENSSL ec -in ee_LDevID_key3_serv.key -pubout >server_pub_key3.pub

$OPENSSL x509 -in root_LDevID.pem  -noout -fingerprint -out fingerprint.txt

#