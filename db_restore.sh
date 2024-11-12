#!/bin/bash

# Variables
DB_NAME="prod_atlas"
DB_USER="root"
DB_PASS="Spr1ngL0g1x"
BACKUP_FILE="mysql_backup_2024-11-12.tar.gz"
DO_BUCKET_NAME="xaur-dev"
DO_BACKUP_FOLDER_NAME="xaur_db_bkp"
RESTORE_FILE="test.sql"   # Specify the path of the extracted .sql file

# Configure s3cmd (if needed)
# s3cmd --configure # Uncomment and configure if not already set up

# Download Backup from DigitalOcean Space using s3cmd
echo "Downloading backup from DigitalOcean Space..."
s3cmd get s3://$DO_BUCKET_NAME/$DO_BACKUP_FOLDER_NAME/$BACKUP_FILE
if [[ $? -ne 0 ]]; then
    echo "Download from DigitalOcean Space failed!"
    exit 1
fi

# Extract the tarball file
echo "Extracting the backup file..."
tar -xvzf $BACKUP_FILE 
if [[ $? -ne 0 ]]; then
    echo "Extraction failed!"
    exit 1
fi

# Restore MySQL Backup
echo "Restoring backup to database: $DB_NAME..."
mysql --binary-mode -u $DB_USER -p$DB_PASS $DB_NAME < "$RESTORE_FILE"
if [[ $? -ne 0 ]]; then
    echo "MySQL restore failed!"
    exit 1
fi

# Clean up local backup files
rm -f "$BACKUP_FILE"       # Remove the original tar.gz file
rm -f "$RESTORE_FILE"      # Remove the extracted SQL file

echo "Restore complete and applied successfully to database: $DB_NAME."

