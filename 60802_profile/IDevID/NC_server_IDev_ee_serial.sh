#!/bin/sh

OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF



# End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_hersteller_ser_key.key

 $OPENSSL req -subj '/serialNumber=123456-ad' \
 -new -sha256  -key ee_hersteller_ser_key.key -out ee_hersteller_ser_req.csr

 #Sign request: end entity extensions
 $OPENSSL  x509 -req -days 365 -in ee_hersteller_ser_req.csr -CA root_hersteller_IDevID.crt -CAkey root_hersteller_IDevID_key.key \
    -CAcreateserial -extfile ca.cnf -extensions usr_cert   -out ee_hersteller_ser.crt
$OPENSSL ec -in ee_hersteller_ser_key.key -pubout >ee_hersteller_pub_key_ser.pub

# TruststoreAdminRole End Entity certificate: create request first
#$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ts_admin.key

# CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
#	-new -sha384  -key ee_LDevID_key_cli_ts_admin.key -out ee_LDevID_req_cli_ts_admin.pem



# KeystoreAdminRole End Entity certificate: create request first
#$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_ks_admin.key

 #CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
#-new -sha384  -key ee_LDevID_key_cli_ks_admin.key -out ee_LDevID_req_cli_ks_admin.pem


# UserMappingAdminRole End Entity certificate: create request first
#$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli_um_admin.key

# CN="cnc" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext.cnf \
#	-new -sha384  -key ee_LDevID_key_cli_um_admin.key -out ee_LDevID_req_cli_um_admin.pem

 




