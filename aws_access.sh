#!/bin/bash



# Set Defaults

DB_USER="confluence_test"
DB_NAME="test_confluence"
DB_PASS="pass"

while getopts :p:s:dh FLAG; do
  case $FLAG in
    db)  #set option "c"
      DB_USER=$USER_DB
      ;;
    du)  #set option "d"
      DB_NAME=$NAME_DB
      ;;
    dp)  #set option "e"
      DB_PASS=$PASS_DB
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


sudo -u postgres bash -c "psql -c \"CREATE ROLE $DB_USER SUPERUSER LOGIN PASSWORD '$DB_PASS'\" "
sudo -u postgres bash -c "createdb --owner $DB_USER $DB_NAME"


