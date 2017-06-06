#!/bin/bash

NORM=`tput sgr0`
BOLD=`tput bold`

# Set Defaults

DB_USER="confluence_test2"
DB_NAME="test_confluence2"
DB_PASS="pass"


while getopts :u:d:p: FLAG; do
  case $FLAG in
    u)  
      DB_USER=$OPTARG
      ;;
    d)  
      DB_NAME=$OPTARG
      ;;
    p)  
      DB_PASS=$OPTARG
      ;;
  esac
done


shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


sudo -u postgres bash -c "psql -c \"CREATE ROLE $DB_USER SUPERUSER LOGIN PASSWORD '$DB_PASS'\" "
sudo -u postgres bash -c "createdb --owner $DB_USER $DB_NAME"


