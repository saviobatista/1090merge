#!/bin/bash
while true;
do
  echo "Capturing SBS data from $1"
  nc "$1" 30003 >> /data/adsb.csv
done