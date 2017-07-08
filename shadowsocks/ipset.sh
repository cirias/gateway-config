#!/bin/bash

# white list for shadow socks 
# wget -q -O $IPSET_LISTS_DIR/cn.zone http://www.ipdeny.com/ipblocks/data/countries/cn.zone
    
LIST_NAME=ip_cn

sudo ipset destroy $LIST_NAME
sudo ipset create $LIST_NAME hash:net 
    
for IP in $(cat ./cn.zone)
do
    sudo ipset add $LIST_NAME $IP
done

sudo ipset create ip_whitelist hash:net timeout 600
