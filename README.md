# 1090merge

This repository contains scripts to capture and merge data from multiple ADS-B basestations into a single file on a daily basis.

## Files

- Dockerfile: Dockerfile for building a Docker image with the necessary tools and scripts.
- capture.sh: Script to capture and merge data from multiple ADS-B basestations.
- cronjob.sh: Cron job script to backup the merged data and clear the data file daily.

## Purpose

The main purpose of this project is to automate the data collection process and merge ADS-B data from multiple basestations into a single file. By consolidating the data, it becomes easier to analyze and extract insights from a broader range of aircraft information.

## Example of Use

To use this project, follow these steps:

1. Build the Docker image using the provided `Dockerfile`.
2. Set the environment variable `HOSTS` to a comma-separated list of ADS-B basestation IP addresses or hostnames.
3. Start the Docker container with the built image.

Be aware that must be open and available at port `30003` on each station to work.

Here's an example command to run the Docker container:

```shell
docker build -t 1090merge .
docker run -d -e HOSTS="192.168.1.100,192.168.1.101,192.168.1.102" 1090merge
```
