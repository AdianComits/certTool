#!/bin/sh

OPENSSL=/home/adian/working_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/working_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF
#Adian Shubbar certTool scripting#



echo "please Enter the number for Certificate type you want to generate for CAN-FD demonstrator : 
1 :herstellerzertifikate
2 :Bewirtschaftungszertifikate
3 :Anwendungszertifikate"

read result 

echo " please enter subject ALt Name fields related to CAN profile "
echo "vendorid:" 
read vendorid
echo "productcode:" 
read productcode
echo "revisionno:" 
read revisionno
echo "serialno:" 
read serialno
echo "certmanagement:" 
read certmanagement
echo "nodeid:" 
read nodeid


subAltName="URI:urn:fieldpki:canopen#devid?=vendorid=$vendorid&productcode=$productcode&revisionno=$revisionno&serialno=$serialno>"


subAltName2="URI:urn:fieldpki:canopen#devid?=vendorid=$vendorid&productcode=$productcode&revisionno=$revisionno&serialno=$serialno>
			urn:fieldpki:canopen#permissions?=certmanagement=$certmanagement"

subAltName3="URI:urn:fieldpki:canopen#devid?=vendorid=$vendorid&productcode=$productcode&revisionno=$revisionno&serialno=$serialno>
			urn:fieldpki:canopen#appid?=nodeid=$nodeid"


case $result in


1)

   # Root Heresteller A: create certificate request then sign it for the date 
$OPENSSL ecparam -name prime256v1  -genkey -out root_hersteller_key.key

 CN="CANopen Device Manufacturer 1 Root CA" ON="CANopen Device Manufacturer 1" $OPENSSL req -new -config ca.cnf  \
	-key root_hersteller_key.key  -sha256 -out root_hersteller_csr.csr

$OPENSSL x509  -startdate 19900101000000Z -enddate 99991231235959Z -extfile ca.cnf -extensions v3_ca  -req -sha256 -in root_hersteller_csr.csr -signkey root_hersteller_key.key -out root_hersteller.crt

# End Entity certificate: create request first
$OPENSSL ecparam -name prime256v1  -genkey -out ee_hersteller_key.key

 CN="human-readable device identity" ON="CANopen Device Manufacturer 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key ee_hersteller_key.key -out ee_hersteller_req.pem

 #Sign request: end entity extensions
URINAME=$subAltName $OPENSSL  x509  -startdate 19900101000000Z -enddate 99991231235959Z -req -in ee_hersteller_req.pem -CA root_hersteller.crt -CAkey root_hersteller_key.key \
	   -extfile ca.cnf -extensions usr_cert   -out ee_hersteller.crt

;;



2)


# Root Bewirtschaftungs CA: create certificate directly
openssl ecparam -name prime256v1  -genkey -out root_Bewirtschaftungs_key.key

 pl="pathlen:1" CN="CANopen Demo Operator 1 Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -new -config ca.cnf  \
	-key root_Bewirtschaftungs_key.key  -sha256 -out root_Bewirtschaftungs_csr.csr
$OPENSSL x509  -startdate 19900101000000Z -enddate 99991231235959Z -extfile ca.cnf -extensions v3_ca  -req -sha256 -in root_Bewirtschaftungs_csr.csr -signkey root_Bewirtschaftungs_key.key -out root_Bewirtschaftungs.crt

# intermediate  Bewirtschaftungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out int_Bewirtschaftungs_key.key

  CN="CANopen Demo Operator 1 Intermediate CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key int_Bewirtschaftungs_key.key -out int_Bewirtschaftungs_req.pem
# Sign request for intermediate : end entity extensions with some variables set 
 pl="pathlen:0"   $OPENSSL  x509 -startdate 19900101000000Z -enddate 99991231235959Z -req -in int_Bewirtschaftungs_req.pem -CA root_Bewirtschaftungs.crt -CAkey root_Bewirtschaftungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions int_cert   -out int_Bewirtschaftungs.crt


# End Entity   Bewirtschaftungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out ee_Bewirtschaftungs_key.key

  CN="human-readable device identity" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key ee_Bewirtschaftungs_key.key -out ee_Bewirtschaftungs_req.pem
# Sign request for End Enity  : end entity extensions with some variables set 
 URINAME2=$subAltName2  pl="pathlen:0"  URINAME=$subAltName $OPENSSL  x509 -startdate 19900101000000Z -enddate 99991231235959Z -req -in ee_Bewirtschaftungs_req.pem -CA int_Bewirtschaftungs.crt -CAkey int_Bewirtschaftungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions usr_extra_cert   -out ee_Bewirtschaftungs.crt

;;


3)


# Root Anwendungs CA: create certificate directly
openssl ecparam -name prime256v1  -genkey -out root_Anwendungs_key.key

 pl="pathlen:1" CN="CANopen Demo Operator 1 Application Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -new -config ca.cnf \
	-key root_Anwendungs_key.key  -sha256 -out root_Anwendungs_csr.csr
$OPENSSL x509  -startdate 19900101000000Z -enddate 99991231235959Z -extfile ca.cnf -extensions v3_ca  -req -sha256 -in root_Anwendungs_csr.csr -signkey root_Anwendungs_key.key -out root_Anwendungs.crt


# intermediate  Anwendungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out int_Anwendungs_key.key

  CN="CANopen Demo Operator 1 Application Root CA" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key int_Anwendungs_key.key -out int_Anwendungs_req.pem
# Sign request for intermediate : end entity extensions 
 pl="pathlen:0"   $OPENSSL  x509 -startdate 19700101000000Z -enddate 99991231235959Z -req -in int_Anwendungs_req.pem -CA root_Anwendungs.crt -CAkey root_Anwendungs_key.key -days 3600 \
	 -extfile ca.cnf -extensions int_cert   -out int_Anwendungs.crt

# End Entity   Anwendungs certificate: create request first
openssl ecparam -name prime256v1  -genkey -out ee_Anwendungs_key.key

  CN="human-readable device identity" ON="CANopen Demo Operator 1" $OPENSSL req -config ca.cnf \
	-new -sha256  -key ee_Anwendungs_key.key -out ee_Anwendungs_req.pem
# Sign request for End Enity  : end entity extensions with some variables set 
 URINAME3=$subAltName3  pl="pathlen:0"  URINAME=$subAltName $OPENSSL  x509 -startdate 19700101000000Z -enddate 99991231235959Z -req -in ee_Anwendungs_req.pem -CA int_Anwendungs.crt -CAkey int_Anwendungs_key.key -days 3600 \
	   -extfile ca.cnf -extensions usr_extra2_cert   -out ee_Anwendungs.crt
;;

*)
echo -n "unkownn"

;;

esac

