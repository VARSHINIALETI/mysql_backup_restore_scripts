# mysql_backup_restore_scripts
MySQL Backup and Restore Scripts with DigitalOcean Spaces:
 
This project contains two shell scripts for backing up and restoring a MySQL database using DigitalOcean Spaces for storage. These scripts help automate the backup process, compress the database, upload it to a DigitalOcean Space, and retrieve and restore the backup when needed.

Prerequisites
MySQL: Ensure MySQL is installed and accessible with the necessary credentials.
s3cmd: s3cmd is required to upload and download files from DigitalOcean Spaces. Install and configure it to interact with DigitalOcean Spaces.

s3cmd Setup for DigitalOcean

Install s3cmd (if not already installed):
		sudo apt-get install s3cmd  # For Debian/Ubuntu systems
Configure s3cmd for DigitalOcean Spaces
Run s3cmd configuration:
		s3cmd --configure
Enter your DigitalOcean Access Key and Secret Key.
For the endpoint, use https://nyc3.digitaloceanspaces.com or another region, like https://ams3.digitaloceanspaces.com for Amsterdam.
Verify Configuration
Run a simple command to confirm s3cmd is configured correctly:
		s3cmd ls s3://your-space-name

Usage
Backup Script
	The backup script creates a compressed MySQL backup and uploads it to      DigitalOcean Space.
Configuration:
Before running the script, update the following placeholders:

DB_NAME: Your MySQL database name.
DB_USER: MySQL username.
DB_PASS: Password for the MySQL user.
DO_BUCKET_NAME: The name of your DigitalOcean Space bucket.
DO_BACKUP_FOLDER_NAME: The folder within the bucket where backups will be stored.

Running the Backup Script:
	
 		./db_backup.sh
	
The script will:
Create a MySQL dump.
Compress the dump into a .tar.gz file.
Upload the compressed file to the specified DigitalOcean Space.
Clean up temporary backup files from the local machine.

Example Output:

		Creating backup for database: logistics_db...
Backup created and compressed as mysql_backup_2024-11-12.tar.gz
Uploading backup to DigitalOcean Space...
Backup uploaded successfully to DigitalOcean Spaces.



Restore Script
	The restore script downloads the latest backup from DigitalOcean Spaces, extracts it, and restores it to the specified MySQL database.

Running the Restore Script:
            
	    ./db_restore.sh
	
The script will:

Download the specified .tar.gz backup file from DigitalOcean Spaces.
Extract the .sql file from the .tar.gz archive.
Restore the database backup to the specified MySQL database.
Clean up temporary files.

Example Output:

  	Downloading backup from DigitalOcean Space...
Backup downloaded successfully
Extracting the backup file...
Restoring backup to database: logistics_db...
Restore complete and applied successfully to database: logistics_db.






