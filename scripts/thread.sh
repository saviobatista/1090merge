#!/bin/bash
while true;
do
  nc "$1" 30003 >> /data/adsb.csv
done