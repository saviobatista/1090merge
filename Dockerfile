# Use a base image with necessary tools
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache netcat-openbsd coreutils dcron flock procps

# Copy the script to capture and store the data
COPY scripts/ /app
RUN chmod +x /app/*

# Add cronjob entry
RUN echo "0 0 * * * /app/cronjob.sh" > /crontab.txt
RUN crontab /crontab.txt

# Create the data and backup directories
RUN mkdir -p /data /backup

# Create initial data file
RUN touch /data/adsb.csv

# Set environment variable for hosts
ENV HOSTS ""

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD pgrep -f "crond" && pgrep -f "thread.sh" || exit 1

# Start the cron service and the script with the passed hosts
CMD [ "sh", "-c", "/app/capture.sh" ]