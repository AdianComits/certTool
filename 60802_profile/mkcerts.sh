#!/bin/sh

OPENSSL=/home/adian/working_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/working_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF

echo "please Enter the number for Certificate type you want to generate : 
1 :set of LDevID zertifikate
2 :LDevID zertifikate"

read result 


case $result in


1)


   # Root Heresteller A: create certificate directly
$OPENSSL ecparam -name prime256v1  -genkey -out root_LDevID_key.key

 CN="adianca" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf -x509 -nodes \
	-key root_LDevID_key.key  -sha384 -out root_LDevID.pem

# TruststoreAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ts_admin.key

 CN="adiancli" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_ts_admin.key -out ee_LDevID_req_cli_ts_admin.pem

 #Sign request: end entity extensions
 role="TruststoreAdminRole"  $OPENSSL  x509   -startdate 19900101000000Z -enddate 99991231235959Z -req -in ee_LDevID_req_cli_ts_admin.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert   -out ee_LDevID_client_ts_admin.crt


# KeystoreAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ks_admin.key

 CN="adiancli" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_ks_admin.key -out ee_LDevID_req_cli_ks_admin.pem

 #Sign request: end entity extensions
 role="KeystoreAdminRole"  $OPENSSL  x509   -startdate 19900101000000Z -enddate 99991231235959Z -req -in ee_LDevID_req_cli_ks_admin.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert   -out ee_LDevID_client_ks_admin.crt



# UserMappingAdminRole End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_um_admin.key

 CN="adiancli" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
	-new -sha384  -key ee_LDevID_key_cli_um_admin.key -out ee_LDevID_req_cli_um_admin.pem

 #Sign request: end entity extensions
 role="UserMappingAdminRole"  $OPENSSL  x509   -startdate 19900101000000Z -enddate 99991231235959Z -req -in ee_LDevID_req_cli_um_admin.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert   -out ee_LDevID_client_um_admin.crt




# sever  End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_serv.key

 CN="localhost" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key_serv.key -out ee_LDevID_req_serv.pem

 #Sign request: end entity extensions
$OPENSSL  x509   -req -in ee_LDevID_req_serv.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert_server   -out ee_LDevID_server.crt

$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_test.key

 CN="test" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf\
	-new -sha384  -key ee_LDevID_key_test.key -out ee_LDevID_req_test.pem

 #Sign request: end entity extensions
$OPENSSL  x509   -req -in ee_LDevID_req_test.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext.cnf -extensions usr_cert_server   -out ee_LDevID_test.crt


$OPENSSL ec -in ee_LDevID_key_serv.key -pubout >server_pub_key.pub
$OPENSSL x509 -in root_LDevID.pem  -noout -fingerprint

#extra command for conversion if needed
#$OPENSSL x509 -in ee_LDevID_client.crt -out ee_LDevID_client.pem -outform PEM
#$OPENSSL x509 -in ee_LDevID_server.crt -out ee_LDevID_server.pem -outform PEM

#$OPENSSL ec -in ee_LDevID_key_cli.key -text > ee_LDevID_key_cli.pem


;;






# ...do something interesting...


2)
# Root Bewirtschaftungs CA: create certificate directly
openssl ecparam -name prime256v1  -genkey -out root_Bewirtschaftungs_key.key

 pl="pathlen:1" CN="CANopen Demo Operator 1 Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf -x509 -nodes \
	-key root_Bewirtschaftungs_key.key  -sha256 -out root_Bewirtschaftungs.crt 

# intermediate  Bewirtschaftungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out int_Bewirtschaftungs_key.key

  CN="CANopen Demo Operator 1 Intermediate CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key int_Bewirtschaftungs_key.key -out int_Bewirtschaftungs_req.pem
# Sign request for intermediate : end entity extensions with some variables set 
 pl="pathlen:0"   $OPENSSL  x509 -req -in int_Bewirtschaftungs_req.pem -CA root_Bewirtschaftungs.crt -CAkey root_Bewirtschaftungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions int_cert -CAcreateserial  -out int_Bewirtschaftungs.crt


# End Entity   Bewirtschaftungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out ee_Bewirtschaftungs_key.key

  CN="human-readable device identity" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key ee_Bewirtschaftungs_key.key -out ee_Bewirtschaftungs_req.pem
# Sign request for End Enity  : end entity extensions with some variables set 
 URINAME2=$subAltName2  pl="pathlen:0"  URINAME=$subAltName $OPENSSL  x509 -req -in ee_Bewirtschaftungs_req.pem -CA int_Bewirtschaftungs.crt -CAkey int_Bewirtschaftungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions usr_extra_cert -CAcreateserial  -out ee_Bewirtschaftungs.crt

;;


*)
echo -n "unkownn"

;;

esac
