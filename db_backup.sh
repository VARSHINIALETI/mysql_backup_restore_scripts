#!/bin/bash
set -x  # Turn on debugging

# Variables
DB_NAME="prod_atlas2"
DB_USER="root"
DB_PASS="Spr1ngL0g1x"
DATE=$(date +%F)
BACKUP_FILE="mysql_backup_$DATE.tar.gz"
DO_BUCKET_NAME="xaur-dev"
DO_BACKUP_FOLDER_NAME="xaur_db_bkp"

# Create MySQL Backup and Compress
echo "Creating backup for database: $DB_NAME..."
mysqldump -u $DB_USER -p$DB_PASS --routines --events --triggers --add-drop-database $DB_NAME > /test.sql
if [[ $? -ne 0 ]]; then
    echo "mysqldump failed! Check /tmp/test.sql for more details."
    exit 1
fi
tar -czvf $BACKUP_FILE /test.sql
if [[ $? -ne 0 ]]; then
    echo "Compression failed!"
    exit 1
fi

# Upload to DigitalOcean Space using s3cmd
echo "Uploading backup to DigitalOcean Space..."
s3cmd put $BACKUP_FILE s3://$DO_BUCKET_NAME/$DO_BACKUP_FOLDER_NAME/$BACKUP_FILE
if [[ $? -ne 0 ]]; then
    echo "Upload to DigitalOcean Space failed!"
    exit 1
fi

# Clean up local backup file
rm /test.sql
rm $BACKUP_FILE
echo "Backup complete and uploaded successfully to DigitalOcean Spaces."

set +x  # Turn off debugging

