#**************************************************************************************
# Author     purpose
#=======     ==========================
# sdepa      purpose of this script is to achieve the below
#            1. Check for the DB Existance and create DB if it is not
#            2. Associate the DB Created with Tablespace,Group Role and Login Role
#            3. Connect to the DB and create required schemas
#**************************************************************************************

#!/bin/bash

###########################################################
# Global Variables Section
###########################################################

OS_USER=`whoami`
logfile=$0_"`date +%m-%d-%Y:%H:%M:%S`".log

##########################################################
# Function for enter functionality
##########################################################

function press_enter
{
echo ""
echo -n "Press Enter to continue"
read
clear
}

##########################################################
# Function to Create DB
##########################################################

function CreateDB
{
echo "Database to Created is:"  $DB

DB_CNT=`psql -l | grep $DB | wc -l`

echo "DB Count is :" $DB_CNT


printf 'Please enter the DB user to be created in database : ' $DB
read DB

export DB_USER=$DB_"USER"
export RW_ROLE=$DB"_RW_ROLE"
export RO_ROLE=$DB"_RO_ROLE"

echo "Creating DB User $DB_USER in: $DB"
echo "Creating Read Only Role  : $RO_ROLE"
echo "Creating Read Write Role : $RW_ROLE"

if [[ "$DB_CNT" = "0" ]];
 then
 psql -U postgres << END_OF_SCRIPT
 CREATE USER $DB_USER WITH PASSWORD 'Password_123';
 CREATE ROLE $RO_ROLE;
 CREATE ROLE $RW_ROLE;
 CREATE DATABASE $DB WITH OWNER = postgres ENCODING = 'UTF8' TABLESPACE = pg_default LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' CONNECTION LIMIT = -1;
 GRANT $RO_ROLE to $DB_USER;
 GRANT $RW_ROLE to $DB_USER;
 GRANT ALL PRIVILEGES ON DATABASE $DB to test;
 ALTER DATABASE $DB OWNER TO $DB_USER;
END_OF_SCRIPT
 else
 echo "Database Exists.... please choose a different DB Name:"
 fi
}

##########################################################
# DB Operation Selection Menu
##########################################################

DB=$1

    if [[ $# -gt 0 ]]; then
    echo " executing the DB Operation Requested:" >> $logfile
    echo " User executing the script : $OS_USER" >> $logfile
    selection=
    until [ "$selection" = "0" ]; do
    echo ""
    echo "PROGRAM MENU"
    echo "1 - Create DB"
    echo "2 - Create Schema"
    echo "3 - Create Group Role"
    echo "4 - Create Login Role"
    echo ""
    echo "0 - exit program"
    echo ""
    echo -n "Enter selection: "
    read selection
    echo ""
    case $selection in
	    1 ) DB_CONN="Create DB"; date ; CreateDB ; press_enter ;;
	    2 ) DB_CONN="Create Schema"; date ; press_enter ;;
	    3 ) DB_CONN="Create Group Role"; date ; press_enter ;;
	    4 ) DB_CONN="Create Login Role"; date ; press_enter ;;
	    0 ) exit ;;
	 ## * ) echo "Please enter 1, 2, 3, 4 or 0"; press_enter
    esac
    done
    else
    echo "Script is missing required input parameters. Please rerun the script with parameters..."
    echo ""
    echo "Usage (Create DB)                 : $0 DBName"
    echo "Usage (Create Schema)             : $0 DBName SchemaName"
    echo "Usage (Create Group Role)         : $0 DBName GroupRoleName"
    echo "Usage (Create Login Role)         : $0 DBName LoginName"
    echo ""
    exit
   fi

