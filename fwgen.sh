#!/bin/sh
ASN=$1
NS_SERVERS=$2
OUTPUT=$3

REGEX="([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.0/[0-9]+"
NSSERVERS=$(cat $NS_SERVERS)

echo Getting prefixes for ASN$ASN...

Prefixes=$(curl -s https://stat.ripe.net/data/announced-prefixes/data.json?resource=AS$1 | jq -c -r .data.prefixes[].prefix | grep -Po $REGEX)

for Prefix in $Prefixes; do
    subnets=$(./cidr-to-subnet.sh $Prefix)
    echo \#in-addr.arpa redirects for $Prefix:
    for subnet in $subnets; do
	IFS=. read -r o1 o2 o3 <<< "$subnet"
	echo $o3.$o2.$o1.in-addr.arpa $NSSERVERS
	done
    echo 
    done