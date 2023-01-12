 #!/bin/sh

sudo sysrepocfg --edit=/home/adian/workspace_60802/netopeer2/example_configuration/tls_keystore.xml  -m ietf-keystore
sudo sysrepocfg --edit=/home/adian/workspace_60802/netopeer2/example_configuration/tls_truststore.xml -m ietf-truststore
sudo sysrepocfg --edit=/home/adian/workspace_60802/netopeer2/example_configuration/tls_listen.xml -m ietf-netconf-server
