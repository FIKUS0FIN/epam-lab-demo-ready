# conflue-postrgesql

u will need Vagrant avalible ports:80 > 8080 ; 443 > 4444 ; 

 and for pure setup confluence u can get access to controle panel from localhost:8090

more then 5 gb memory -- java + tomcat + confluence + nginx 

	vagrant up --provision

	vagrant ssh 

#LOG IN like postgres user 

	sudo -i -u postgres

#export some US.UTF-8	

	export LANGUAGE=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_TYPE=en_US.UTF-8

#creating db user and db 

	bash -c "psql -c \"CREATE ROLE confluenceuser with LOGIN PASSWORD 'pass'\" "

	bash -c "createdb --owner confluenceuser  confluence"

#now u can config confluence from localhost:8090 

-----------------------------------------------------------------------------------

#next ssh tounel to es2 443:4444:4444 
#                       vag:local:es2

	 ssh -p 2222 -i nvi.pem -R 4444:localhost:4444 ubuntu@ec2-52-90-192-5.compute-1.amazonaws.com

# FOR USING SSH FORVARDING 

	 ssh -p 2222 -i nvi.pem -L 5432:localhost:5432 ubuntu@ec2-52-90-192-5.compute-1.amazonaws.com

# ACCESS

https://ec2-52-90-192-5.compute-1.amazonaws.com:4444/

#after and use 
	vagrant destroy
	rm -rf .vagrant/

## for external datebese on aws use 
	host: ec2-52-90-192-5.compute-1.amazonaws.com
	confluenceuser
	pass


# for setup aws db for external world 

vim /etc/postgresql/9.5/main/postgresql.conf

	edit to : listen_addresses = '*'

vim  /etc/postgresql/9.5/main/pg_hba.conf

	# TYPE  DATABASE        USER            ADDRESS                 METHOD

	# "local" is for Unix domain socket connections only
	local   all         all                               trust
	
	# IPv4 local connections:
	host    all         all         127.0.0.1/32          trust
	host    all         all         178.212.111.39/8       trust


# u can run aws_access.sh on aws server and reate new DB and DB_USER 

	chmod a+x aws_access.sh 
	./aws_access.sh -u "db name" -d "db user" -p "db pass"

# for castom setup confluence postreSQ and nginx servers 
u can run script from vagrant hox 

	./demo.sh -h  {-h means help}










