#!/bin/sh
for host in ${HOSTS//,/ }
do
  sh /app/thread.sh "$host" &
done

crond -f