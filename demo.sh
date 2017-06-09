#!/bin/bash

# Installing nginx + ssl 

NORM=`tput sgr0`
BOLD=`tput bold`


function HELP {
  echo -e \\n"Help documentation Confluense install + postgreSQL + Nginx(ssl)"\\n
  echo -e "Basic usage: demo.sh"\\n
  echo "-p [PORT]   --Sets the value for port used for the application. Default is ${BOLD}8090${NORM}."
  echo "-s [SERVER] --Sets the value for the server name. Default is ${BOLD}the IP address${NORM}."
  echo "-d [DATA_BASE] -- Set  IF u don't need postgresql on server. Default is ${BOLD}YES${NORM}."
  echo "-c [CONFLUENCE] -- Set if u dont't nned confluense on server.Default is ${BOLD}YES${NORM}. "
  cho "-t  [SERVER_TYPE] {DEV/QA/STAGE/PROD } -- select type of server. Default is ${BOLD}DEV${NORM}. "
  echo -e "-h  --Displays this help message."\\n
  echo -e "Example: sudo bash demo.sh -p 8091 -s test.example.com -c -d "\\n
  exit 1
}

IP_ADDRESS="$(ifconfig | egrep -o -m 1 'inet addr:[0-9|.]+' | egrep -o '[0-9|.]+')"

# Set Defaults
OPT_A="8090"
SERVER_NAME=$IP_ADDRESS
DATA_BASE="True"
CONFLUENCE="True"
DEV_SERVER="DEV"

while getopts :p:s:t:cdh FLAG; do
  case $FLAG in
    p)  #set option "a"
      OPT_A=$OPTARG
      ;;
    s)  #set option "b"
      SERVER_NAME=$OPTARG
      ;;
    c) #deceible confluence 
      CONFLUENCE="False"
      ;;
    d) #for desable sql 
      DATA_BASE="False"
      ;;
    t) # type of server
      DEV_SERVER=$OPTARG
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

echo "$OPT_A"
echo "$SERVER_NAME"
echo "$DATA_BASE"
echo "$CONFLUENCE"
echo "$DEV_SERVER"


# FOR DEV SERVER
if [ $DEV_SERVER = "DEV" ]
then

        cd nginx/
        sudo add-apt-repository -y ppa:nginx/stable
        sudo apt-get update
        sudo apt-get -y install nginx
        cp local.conf /etc/nginx/conf.d/local.conf
        mkdir -p /etc/nginx/ssl
        cp ssl.rules /etc/nginx/ssl/ssl.rules
        cp nginx.conf /etc/nginx/nginx.conf

        # Generate the Keys

            mkdir -p /etc/nginx/ssl/keys
            openssl genpkey -algorithm RSA -out /etc/nginx/ssl/keys/private.key -pkeyopt rsa_keygen_bits:2048
            openssl rsa -in /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/private-decrypted.key
            openssl req -new -sha256 -key /etc/nginx/ssl/keys/private-decrypted.key -subj "/CN=$SERVER_NAME" -out /etc/nginx/ssl/keys/$SERVER_NAME.csr
            openssl x509 -req -days 365 -in /etc/nginx/ssl/keys/$SERVER_NAME.csr -signkey /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/server.crt
            rm /etc/nginx/ssl/keys/private-decrypted.key
            rm /etc/nginx/ssl/keys/$SERVER_NAME.csr

        openssl dhparam -outform pem -out /etc/nginx/ssl/dhparam2048.pem 2048

        sed -i "s/SERVER_NAME/$SERVER_NAME/" /etc/nginx/conf.d/local.conf
        sed -i "s/PORT_NUMBER/$OPT_A/" /etc/nginx/conf.d/local.conf

        sudo service nginx restart

        # next part installing confluense 
        if [ $CONFLUENCE = "True" ]
        then
            cd .. 
            echo -e "\e[1;31m HERE IS  installing confluense \e[0m"
            mkdir -p It_start
            sudo ./atlassian-confluence-6.2.1-x64.bin < atl-comand
            echo -e "\e[1;31m atlasian instaletion finish \e[0m"
        else
            echo -e "\e[1;31m no confluense here  \e[0m"
        fi


        # instaling postgreSQL and dependensy 
        if [ $DATA_BASE = "True" ]
        then  
            sudo locale-gen en_US.UTF-8
            sudo apt-get update
            sudo apt-get install -y postgresql postgresql-contrib
            sudo mkdir -p /var/atlassian/application-data/confluence/restore
        else
            echo -e "\e[1;31m U don't need sql good lack  \e[0m"
        fi 


        echo -e "\e[1;31m SO WE DONE > NOW U NEED \e[0m"
        echo -e "\e[1;31m CREATE db AND db_USER \e[0m"
        echo -e "\e[1;31m or conect to external db on aws  \e[0m"
        echo -e "\e[1;31m IT'S DEV_SERVER  \e[0m"

elif [[ $DEV_SERVER = "QA" ]]; then

        cd nginx/
        sudo add-apt-repository -y ppa:nginx/stable
        sudo apt-get update
        sudo apt-get -y install nginx
        cp local.conf /etc/nginx/conf.d/local.conf
        mkdir -p /etc/nginx/ssl
        cp ssl.rules /etc/nginx/ssl/ssl.rules
        cp nginx.conf /etc/nginx/nginx.conf

        # Generate the Keys

            mkdir -p /etc/nginx/ssl/keys
            openssl genpkey -algorithm RSA -out /etc/nginx/ssl/keys/private.key -pkeyopt rsa_keygen_bits:2048
            openssl rsa -in /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/private-decrypted.key
            openssl req -new -sha256 -key /etc/nginx/ssl/keys/private-decrypted.key -subj "/CN=$SERVER_NAME" -out /etc/nginx/ssl/keys/$SERVER_NAME.csr
            openssl x509 -req -days 365 -in /etc/nginx/ssl/keys/$SERVER_NAME.csr -signkey /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/server.crt
            rm /etc/nginx/ssl/keys/private-decrypted.key
            rm /etc/nginx/ssl/keys/$SERVER_NAME.csr

        openssl dhparam -outform pem -out /etc/nginx/ssl/dhparam2048.pem 2048

        sed -i "s/SERVER_NAME/$SERVER_NAME/" /etc/nginx/conf.d/local.conf
        sed -i "s/PORT_NUMBER/$OPT_A/" /etc/nginx/conf.d/local.conf

        sudo service nginx restart

        # next part installing confluense 
        if [ $CONFLUENCE = "True" ]
        then
            cd .. 
            echo -e "\e[1;31m HERE IS  installing confluense \e[0m"
            mkdir -p It_start
            sudo ./atlassian-confluence-6.2.1-x64.bin < atl-comand
            echo -e "\e[1;31m atlasian instaletion finish \e[0m"
        else
            echo -e "\e[1;31m no confluense here  \e[0m"
        fi


        # instaling postgreSQL and dependensy 
        if [ $DATA_BASE = "True" ]
        then  
            sudo locale-gen en_US.UTF-8
            sudo apt-get update
            sudo apt-get install -y postgresql postgresql-contrib
            sudo mkdir -p /var/atlassian/application-data/confluence/restore
        else
            echo -e "\e[1;31m U don't need sql good lack  \e[0m"
        fi 


        echo -e "\e[1;31m SO WE DONE > NOW U NEED \e[0m"
        echo -e "\e[1;31m CREATE db AND db_USER \e[0m"
        echo -e "\e[1;31m or conect to external db on aws  \e[0m"
        echo -e "\e[1;31m IT'S QA_SERVER  \e[0m"
elif [[ $DEV_SERVER = "STAGE" ]]; then
  
        cd nginx/
        sudo add-apt-repository -y ppa:nginx/stable
        sudo apt-get update
        sudo apt-get -y install nginx
        cp local.conf /etc/nginx/conf.d/local.conf
        mkdir -p /etc/nginx/ssl
        cp ssl.rules /etc/nginx/ssl/ssl.rules
        cp nginx.conf /etc/nginx/nginx.conf

        # Generate the Keys

            mkdir -p /etc/nginx/ssl/keys
            openssl genpkey -algorithm RSA -out /etc/nginx/ssl/keys/private.key -pkeyopt rsa_keygen_bits:2048
            openssl rsa -in /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/private-decrypted.key
            openssl req -new -sha256 -key /etc/nginx/ssl/keys/private-decrypted.key -subj "/CN=$SERVER_NAME" -out /etc/nginx/ssl/keys/$SERVER_NAME.csr
            openssl x509 -req -days 365 -in /etc/nginx/ssl/keys/$SERVER_NAME.csr -signkey /etc/nginx/ssl/keys/private.key -out /etc/nginx/ssl/keys/server.crt
            rm /etc/nginx/ssl/keys/private-decrypted.key
            rm /etc/nginx/ssl/keys/$SERVER_NAME.csr

        openssl dhparam -outform pem -out /etc/nginx/ssl/dhparam2048.pem 2048

        sed -i "s/SERVER_NAME/$SERVER_NAME/" /etc/nginx/conf.d/local.conf
        sed -i "s/PORT_NUMBER/$OPT_A/" /etc/nginx/conf.d/local.conf

        sudo service nginx restart

        # next part installing confluense 
        if [ $CONFLUENCE = "True" ]
        then
            cd .. 
            echo -e "\e[1;31m HERE IS  installing confluense \e[0m"
            mkdir -p It_start
            sudo ./atlassian-confluence-6.2.1-x64.bin < atl-comand
            echo -e "\e[1;31m atlasian instaletion finish \e[0m"
        else
            echo -e "\e[1;31m no confluense here  \e[0m"
        fi


        # instaling postgreSQL and dependensy 
        if [ $DATA_BASE = "True" ]
        then  
            sudo locale-gen en_US.UTF-8
            sudo apt-get update
            sudo apt-get install -y postgresql postgresql-contrib
            sudo mkdir -p /var/atlassian/application-data/confluence/restore
        else
            echo -e "\e[1;31m U don't need sql good lack  \e[0m"
        fi 


        echo -e "\e[1;31m SO WE DONE > NOW U NEED \e[0m"
        echo -e "\e[1;31m CREATE db AND db_USER \e[0m"
        echo -e "\e[1;31m or conect to external db on aws  \e[0m"
        echo -e "\e[1;31m IT'S STAGE_SERVER  \e[0m"
else 
       echo -e "\e[1;31m I NEED PARAMETR -t   \e[0m"
fi







