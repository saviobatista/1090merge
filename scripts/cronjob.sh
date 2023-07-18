#!/bin/sh
PREVIOUS_DAY=$(date -d "yesterday" +%Y%m%d)
SOURCE_FILE="/data/adsb.csv"
TEMP_FILE="/data/temp_adsb.csv"
TARGET_FILE="/backup/adsb-log_${PREVIOUS_DAY}.csv"

(
  # Wait for lock on $SOURCE_FILE (fd 200) for 10 seconds
  flock -w 10 200 || exit 1

  # Copy the file to a temporary file
  cp "$SOURCE_FILE" "$TEMP_FILE"
  
  # Empty the source file
  > "$SOURCE_FILE"
  
) 200>"$SOURCE_FILE.lock"

# Now copy the temporary file to the backup and remove the temporary file
cp "$TEMP_FILE" "$TARGET_FILE"
rm "$TEMP_FILE"

# Check if the copy operation was successful
if [ $? -eq 0 ]; then
  echo "Backup successfully."
else
  echo "Error during the backup operation."
fi
