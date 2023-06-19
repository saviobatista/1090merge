#!/bin/sh
PREVIOUS_DAY=$(date -d "yesterday" +%Y%m%d)
cp /data/adsb.csv "/backup/adsb-log_${PREVIOUS_DAY}.csv"
> /data/adsb.csv