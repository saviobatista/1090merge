#!/bin/sh
while IFS= read -r host; do
    echo "$host"
    nc -d "$host" 30003 >> /data/adsb.csv &
done < /data/hosts.txt