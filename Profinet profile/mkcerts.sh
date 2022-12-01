#!/bin/sh

OPENSSL=/home/adian/working_60802/openssl/apps/openssl
OPENSSL_CONF=/home/adian/working_60802/openssl/apps/openssl.cnf
#export OPENSSL_CONF
#Adian Shubbar certTool scripting#


echo "please Enter the number of the Certificate type you want to generate for Profinet 
1: IDevID
2: LDevID-Generic
3: LDevPN "

read result 



subAltName="URI:urn:pi:security#verifiable-component-identity?=VendorID=$vendorid&orderid=$orderid&IM_Serial_Number=$IM_Serial_Number&IM_Hardware_Revision=$IM_Hardware_Revision>"

subAltName2="URI:urn:pi:security#verifiable-component-identity?=VendorID=$vendorid&orderid=$orderid&IM_Serial_Number=$IM_Serial_Number&IM_Hardware_Revision=$IM_Hardware_Revision>"



case $result in


1)

echo "please Enter the subjject altname Attributes for Profinet "
echo "vendorid:" 
read vendorid
echo "orderid:" 
read orderid
echo "IM_Serial_Number:" 
read IM_Serial_Number
echo "IM_Hardware_Revision:" 
read IM_Hardware_Revision

   # IDev Root : create root certificate directly
openssl ecparam -name secp521r1  -genkey -out IDevID_key.key

 CN=" Device Manufacturer 1 Root CA" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf -x509 -nodes \
	-key IDevID_key.key -sha512 -out IDevID.crt 

# End Entity certificate IDev EE: create request first
openssl ecparam -name secp521r1  -genkey -out IDevID_ee_key.key

 CN="human-readable device identity" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf \
	-new -sha512  -key IDevID_ee_key.key -out IDevID_ee_req.pem
# Sign request: end entity extensions
URINAME=$subAltName $OPENSSL  x509 -req -in IDevID_ee_req.pem -CA IDevID.crt  -CAkey IDevID_key.key -days 3600 \
	   -extfile ca.cnf -extensions usr_cert   -out IDevID_ee_cert.crt

;;

2)

echo "please Enter the subjject altname Attributes for Profinet "
echo "vendorid:" 
read vendorid
echo "orderid:" 
read orderid
echo "IM_Serial_Number:" 
read IM_Serial_Number
echo "IM_Hardware_Revision:" 
read IM_Hardware_Revision

  # LDev Root : create root certificate directly
openssl ecparam -name secp521r1  -genkey -out LDevID_key.key

 CN="Device Manufacturer 1 Root CA" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf -x509 -nodes \
	-key LDevID_key.key -sha512 -out LDevID.crt 

# End Entity certificate LDev EE: create request first
openssl ecparam -name secp521r1  -genkey -out LDevID_ee_key.key

 CN="human-readable device identity" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf \
	-new -sha512  -key LDevID_ee_key.key -out LDevID_ee_req.pem
# Sign request: end entity extensions
URINAME2=$subAltName2 $OPENSSL  x509 -startdate 19900101000000Z  -enddate 99991231235959Z -req -in LDevID_ee_req.pem -CA LDevID.crt  -CAkey LDevID_key.key  \
	   -extfile ca.cnf -extensions usr_extra_cert -out LDevID_ee_cert.crt



;;

3)

  # LDevPN Root : create root certificate directly
openssl ecparam -name secp521r1  -genkey -out LDevID_PN_key.key

 CN="Device Manufacturer 1 Root CA" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf -x509 -nodes \
	-key LDevID_PN_key.key -sha512 -out LDevID_PN.crt 

# End Entity certificate LDevPN EE: create request first
openssl ecparam -name secp521r1  -genkey -out LDevID_ee_PN_key.key

 CN="human-readable device identity" ON="Device Manufacturer 1" $OPENSSL req -config ca.cnf \
	-new -sha512  -key LDevID_ee_PN_key.key -out LDevID_ee_PN_req.pem
# Sign request: end entity extensions
 $OPENSSL  x509 -startdate 19900101000000Z  -enddate 99991231235959Z -req -in LDevID_ee_PN_req.pem -CA LDevID_PN.crt  -CAkey LDevID_PN_key.key  \
	   -extfile ca.cnf -extensions usr_extra2_cert -out LDevID_ee_PN_cert.crt


;;

*)
echo -n "unkownn"

;;

esac

