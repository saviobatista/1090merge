#!/bin/sh

PREVIOUS_DAY=$(date -d "yesterday" +%Y%m%d)
SOURCE_FILE="/data/adsb.csv"
TEMP_FILE="/data/temp_adsb.csv"
BACKUP_DIR="/backup"
TARGET_FILE="$BACKUP_DIR/adsb-log_${PREVIOUS_DAY}.csv"

echo "$(date): Starting daily backup process"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Check if source file exists and has content
if [ ! -f "$SOURCE_FILE" ]; then
    echo "$(date): ERROR: Source file $SOURCE_FILE does not exist"
    exit 1
fi

if [ ! -s "$SOURCE_FILE" ]; then
    echo "$(date): WARNING: Source file $SOURCE_FILE is empty, creating empty backup"
    touch "$TARGET_FILE"
    > "$SOURCE_FILE"
    echo "$(date): Empty backup created for $PREVIOUS_DAY"
    exit 0
fi

echo "$(date): Source file size: $(wc -l < "$SOURCE_FILE") lines"

# Use file locking to prevent data corruption
(
    # Wait for lock on $SOURCE_FILE (fd 200) for 30 seconds
    flock -w 30 200 || {
        echo "$(date): ERROR: Could not acquire lock on $SOURCE_FILE"
        exit 1
    }
    
    echo "$(date): Lock acquired, copying data..."
    
    # Copy the file to a temporary file
    if cp "$SOURCE_FILE" "$TEMP_FILE"; then
        echo "$(date): Successfully copied to temp file"
        
        # Empty the source file
        > "$SOURCE_FILE"
        echo "$(date): Source file cleared"
    else
        echo "$(date): ERROR: Failed to copy source file"
        exit 1
    fi
    
) 200>"$SOURCE_FILE.lock"

# Check if temp file was created successfully
if [ ! -f "$TEMP_FILE" ]; then
    echo "$(date): ERROR: Temp file was not created"
    exit 1
fi

# Copy the temporary file to the backup
if cp "$TEMP_FILE" "$TARGET_FILE"; then
    echo "$(date): Backup successfully created: $TARGET_FILE"
    echo "$(date): Backup file size: $(wc -l < "$TARGET_FILE") lines"
else
    echo "$(date): ERROR: Failed to create backup file"
    # Restore the data to source file if backup failed
    cp "$TEMP_FILE" "$SOURCE_FILE"
    echo "$(date): Data restored to source file due to backup failure"
    exit 1
fi

# Clean up temp file
rm -f "$TEMP_FILE"

echo "$(date): Daily backup process completed successfully"
