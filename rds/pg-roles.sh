#**************************************************************************************
# Author     purpose
#=======     ==========================
# sdepa      purpose of this script is to achieve the below
#            1. Connect to Postgres Database based on the inputs provided
#                -- 1. DB Host
#                -- 2. DB Name
#            2. Based on the Input, Connect to the DB
#            3. Perform the operation intended
#**************************************************************************************

#! /bin/bash
# Script to connect to DB

echo -en "              ******** SCRIPT OWNERS: BREEDING ENGG TEAM********                 \n"
echo "                                                                                              "
# Please provide requested inputs

echo -en "******** POSTGRES DATABASE HOST AND DB Name Details:******** \n"
echo "                                                                                              "

printf 'Please input DB Host in UPPERCASE :'
read DBHost

printf 'Please input Maintenance DB Name in UPPERCASE :'
read MaintDBName

echo "Your are Now Connecting to Maintenance DB: ($MaintDBName) on Host: ($DBHost)"
echo "                                                                                              "

printf 'Please choose your Action :'

select action in createdatabase creategrouprole createloginrole
do
echo -en $action > action
break
done

case $action in
     createdatabase)
                echo -en "******** Creating a New Database in ($DBHost) :******** \n"
                echo "                                                                                              "
                psql -e -U postgres -h $DBHost $MaintDBName -c "select * from pg_tables where tablespace='pg_global'"
                echo "                                                                                              "
                if [ "$?" != "0" ]; then
                echo "DB Creation is not Sucessfull"
                exit $psql_exit_status
                else
                echo "DB Creation is Sucessfull"
                fi
                ;;
    creategrouprole)
                echo -en "******** Creating a New Grouprole in ($DBHost) :******** \n"
                echo "                                                                                              "
                psql -e -U postgres -h $DBHost $MaintDBName -c "select * from pg_tables where tablespace='pg_global'"
                echo "                                                                                              "
                if [ "$?" != "0" ]; then
                echo "Grouprole Creation is not Sucessfull"
                exit $psql_exit_status
                else
                echo "Grouprole Created Sucessfull"
                fi
                ;;
    createloginrole)
                echo -en "******** Creating a New Loginrole in ($DBHost) :******** \n"
                echo "                                                                                              "
                psql -e -U postgres -h $DBHost $MaintDBName -c "select * from pg_tables where tablespace='pg_global'"
                echo "                                                                                              "
                if [ "$?" != "0" ]; then
                echo "Loginrole Creation is not Sucessfull"
                exit $psql_exit_status
                else
                echo "Loginrole Created Sucessfull"
                fi
                ;;
esac

echo "                                                                                              "
echo "sql script successful"
exit 0

