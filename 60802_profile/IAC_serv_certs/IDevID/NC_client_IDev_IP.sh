#!/bin/sh

OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF


  # Root Heresteller A: create certificate request then sign it for the date 
$OPENSSL ecparam -name prime256v1  -genkey -out root_hersteller_IDev_ip_key.key

 CN="IDev Root CA" ON="Device Manufacturer 1" $OPENSSL req -new -config ca.cnf  \
	-key root_hersteller_IDev_ip_key.key  -sha256 -out root_hersteller_IDev_ip_csr.csr

$OPENSSL x509 -extfile ca.cnf -extensions v3_ca  -req -sha256 -in root_hersteller_IDev_ip_csr.csr -signkey root_hersteller_IDev_ip_key.key -out root_hersteller_ip_IDev.crt

# End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_hersteller_ip_key.key

CN="10.10.10.1" ON=" Device Manufacturer 1" $OPENSSL req -config ca.cnf -new -sha256  -key ee_hersteller_ip_key.key -out ee_hersteller_ip_req.csr

 #Sign request: end entity extensions
 $OPENSSL  x509 -req -in ee_hersteller_ip_req.csr -CA root_hersteller_ip_IDev.crt -CAkey root_hersteller_IDev_ip_key.key \
    -CAcreateserial -extfile ca.cnf -extensions usr_cert   -out ee_hersteller_ip.crt
$OPENSSL ec -in ee_hersteller_ip_key.key -pubout >IDev_pub_key.pub

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

 




