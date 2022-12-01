#!/bin/sh

OPENSSL=/home/adian/workspace_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/workspace_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF

echo "please Enter the number for Certificate type you want to generate : 
1 :IDevID zertifikate
2 :LDevID zertifikate"

read result 


#echo "serialno:" 
#read serialno

#subAltName="URI:urn:60802#LDevid?=serialno=$serialno>"





case $result in


1)


   # Root Heresteller A: create certificate directly
$OPENSSL ecparam -name prime256v1  -genkey -out root_LDevID_key.key

 CN="adianca" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext_OID.cnf -x509 -nodes \
	-key root_LDevID_key.key  -sha384 -out root_LDevID.pem

# 1st End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_cli.key

 CN="adiancli" ON=" Device Manufacturer 1" $OPENSSL req -config ca_ext_OID.cnf \
	-new -sha384  -key ee_LDevID_key_cli.key -out ee_LDevID_req_cli.pem

 #Sign request: end entity extensions
URINAME=$subAltName $OPENSSL  x509   -req -in ee_LDevID_req_cli.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext_OID.cnf -extensions usr_cert   -out ee_LDevID_client.crt

# 2nd End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_LDevID_key_serv.key

 CN="localhost" ON="Device Manufacturer 1" $OPENSSL req -config ca_ext_OID.cnf\
	-new -sha384  -key ee_LDevID_key_serv.key -out ee_LDevID_req_serv.pem

 #Sign request: end entity extensions
URINAME=$subAltName $OPENSSL  x509   -req -in ee_LDevID_req_serv.pem -CA root_LDevID.pem -CAkey root_LDevID_key.key \
	   -extfile ca_ext_OID.cnf -extensions usr_cert_server   -out ee_LDevID_server.crt

$OPENSSL ec -in ee_LDevID_key_serv.key -pubout >server_pub_key.pub
$OPENSSL x509 -in root_LDevID.pem  -noout -fingerprint
$OPENSSL x509 -in ee_LDevID_client.crt -out ee_LDevID_client.pem -outform PEM
$OPENSSL x509 -in ee_LDevID_server.crt -out ee_LDevID_server.pem -outform PEM

$OPENSSL ec -in ee_LDevID_key_cli.key -text > ee_LDevID_key_cli.pem


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




3)

# Root Anwendungs CA: create certificate directly
openssl ecparam -name prime256v1  -genkey -out root_Anwendungs_key.key

 pl="pathlen:1" CN="CANopen Demo Operator 1 Application Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf -x509 -nodes \
	-key root_Anwendungs_key.key  -sha256 -out root_Anwendungs.crt 


# intermediate  Anwendungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out int_Anwendungs_key.key

  CN="CANopen Demo Operator 1 Application Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key int_Anwendungs_key.key -out int_Anwendungs_req.pem
# Sign request for intermediate : end entity extensions 
 pl="pathlen:0"   $OPENSSL  x509 -req -in int_Anwendungs_req.pem -CA root_Anwendungs.crt -CAkey root_Anwendungs_key.key -days 3600 \
	 -extfile ca.cnf -extensions int_cert -CAcreateserial  -out int_Anwendungs.crt

# End Entity   Anwendungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out ee_Anwendungs_key.key

  CN="human-readable device identity" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key ee_Anwendungs_key.key -out ee_Anwendungs_req.pem
# Sign request for End Enity  : end entity extensions with some variables set 
 URINAME3=$subAltName3  pl="pathlen:0"  URINAME=$subAltName $OPENSSL  x509 -req -in ee_Anwendungs_req.pem -CA int_Anwendungs.crt -CAkey int_Anwendungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions usr_extra2_cert -CAcreateserial  -out ee_Anwendungs.crt
;;

*)
echo -n "unkownn"

;;

esac

#open ee_hersteller.crt

# Server certificate: create request first
#CN="Test Server Cert" $OPENSSL req -config ca.cnf -nodes \
#	-keyout server.key -out sreq.pem -newkey rsa:1024
# Sign request: end entity extensions
#$OPENSSL x509 -req -in sreq.pem -CA root.crt -CAkey root.key -days 3600 \
#	-extfile ca.cnf -extensions usr_cert -CAcreateserial -out server.crt
#
# Client certificate: request first
#CN="Test Client Cert" $OPENSSL req -config ca.cnf -nodes \
#	-keyout client.key -out creq.pem -newkey rsa:1024
# Sign using intermediate CA
#$OPENSSL x509 -req -in creq.pem -CA root.crt -CAkey root.key  -days 3600 \
#	-extfile ca.cnf -extensions usr_cert -CAcreateserial -out client.crt
#
## Revoked certificate: request first
#CN="Test Revoked Cert" $OPENSSL req -config ca.cnf -nodes \
#	-keyout revkey.pem -out rreq.pem -newkey rsa:1024
## Sign using intermediate CA
#$OPENSSL x509 -req -in rreq.pem -CA intca.pem -CAkey intkey.pem -days 3600 \
#	-extfile ca.cnf -extensions usr_cert -CAcreateserial -out rev.pem
#
## OCSP responder certificate: request first
#CN="Test OCSP Responder Cert" $OPENSSL req -config ca.cnf -nodes \
#	-keyout respkey.pem -out respreq.pem -newkey rsa:1024
## Sign using intermediate CA and responder extensions
#$OPENSSL x509 -req -in respreq.pem -CA intca.pem -CAkey intkey.pem -days 3600 \
#	-extfile ca.cnf -extensions ocsp_cert -CAcreateserial -out resp.pem
#
## Example creating a PKCS#3 DH certificate.
#
## First DH parameters
#
#[ -f dhp.pem ] || $OPENSSL genpkey -genparam -algorithm DH -pkeyopt dh_paramgen_prime_len:1024 -out dhp.pem
#
## Now a DH private key
#$OPENSSL genpkey -paramfile dhp.pem -out dhskey.pem
## Create DH public key file
#$OPENSSL pkey -in dhskey.pem -pubout -out dhspub.pem
## Certificate request, key just reuses old one as it is ignored when the
## request is signed.
#CN="Test Server DH Cert" $OPENSSL req -config ca.cnf -new \
#	-key skey.pem -out dhsreq.pem
## Sign request: end entity DH extensions
#$OPENSSL x509 -req -in dhsreq.pem -CA root.pem -days 3600 \
#	-force_pubkey dhspub.pem \
#	-extfile ca.cnf -extensions dh_cert -CAcreateserial -out dhserver.pem
#
## DH client certificate
#
#$OPENSSL genpkey -paramfile dhp.pem -out dhckey.pem
#$OPENSSL pkey -in dhckey.pem -pubout -out dhcpub.pem
#CN="Test Client DH Cert" $OPENSSL req -config ca.cnf -new \
#	-key skey.pem -out dhcreq.pem
#$OPENSSL x509 -req -in dhcreq.pem -CA root.pem -days 3600 \
#	-force_pubkey dhcpub.pem \
#	-extfile ca.cnf -extensions dh_cert -CAcreateserial -out dhclient.pem
#
## Examples of CRL generation without the need to use 'ca' to issue
## certificates.
## Create zero length index file
#>index.txt
## Create initial crl number file
#echo 01 >crlnum.txt
## Add entries for server and client certs
#$OPENSSL ca -valid server.pem -keyfile root.pem -cert root.pem \
#		-config ca.cnf -md sha1
#$OPENSSL ca -valid client.pem -keyfile root.pem -cert root.pem \
#		-config ca.cnf -md sha1
#$OPENSSL ca -valid rev.pem -keyfile root.pem -cert root.pem \
#		-config ca.cnf -md sha1
## Generate a CRL.
#$OPENSSL ca -gencrl -keyfile root.pem -cert root.pem -config ca.cnf \
#		-md sha1 -crldays 1 -out crl1.pem
## Revoke a certificate
#openssl ca -revoke rev.pem -crl_reason superseded \
#		-keyfile root.pem -cert root.pem -config ca.cnf -md sha1
## Generate another CRL
#$OPENSSL ca -gencrl -keyfile root.pem -cert root.pem -config ca.cnf \
#		-md sha1 -crldays 1 -out crl2.pem
#
#
