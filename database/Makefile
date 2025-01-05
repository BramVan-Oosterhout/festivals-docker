# create docker image for festivals-database

database: 
	echo mkdir database
	mkdir database

install.sh: install-node.sh
	curl -L -o install.sh https://github.com/Festivals-App/festivals-database/raw/main/operation/install_database.sh

install_node.sh: 
	curl -o install_node.sh https://raw.githubusercontent.com/Festivals-App/festivals-database/main/operation/install_node.sh

base: rm-base
	docker build --progress=plain --no-cache -f base.dck --tag my/base_database .
rm-base:
	-docker rmi my/base_database

configure:
	docker build --progress=plain --no-cache -f configure.dck --tag my/database .

run:
	docker run --name festivals-database \
				--detach \
				my/database
				


net-up:
	echo net-up
	docker network create festivals
	

    