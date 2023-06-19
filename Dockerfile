# Use a base image with necessary tools
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache netcat-openbsd coreutils dcron

# Copy the script to capture and store the data
COPY scripts/ /app
RUN chmod +x /app/*

# Add cronjob entry
RUN echo "0 0 * * * /app/cronjob.sh" > /crontab.txt
RUN crontab /crontab.txt

# Create the data directory
RUN mkdir /data

RUN touch /data/adsb.csv

# Set environment variable for hosts
ENV HOSTS ""

# Start the cron service and the script with the passed hosts
CMD [ "sh", "-c", "/app/capture.sh" ]