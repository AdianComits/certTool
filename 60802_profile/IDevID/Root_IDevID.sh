#!/bin/sh

OPENSSL=openssl
OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
export OPENSSL_CONF


  # Root Heresteller IDEVID A: create certificate request then sign it
$OPENSSL ecparam -name prime256v1  -genkey -out root_hersteller_IDevID_key.key

 CN="IDev Root CA" ON="Device Manufacturer 1" $OPENSSL req -days 365 -new -config ca.cnf  \
	-key root_hersteller_IDevID_key.key  -sha256 -out root_hersteller_IDev_csr.csr

$OPENSSL x509 -extfile ca.cnf -extensions v3_ca  -req -days 365 -sha256 -in root_hersteller_IDev_csr.csr -signkey root_hersteller_IDevID_key.key -out root_hersteller_IDevID.crt

