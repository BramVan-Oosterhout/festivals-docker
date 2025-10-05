# Make recipes applying to all servers

SERVERS=festivals-identity-server festivals-gateway \
	festivals-fileserver festivals-database \
	festivals-server festivals-website festivals-ui

ALL-UP = $(patsubst %,%.up,${SERVERS})
ALL-DOWN = $(patsubst %,%.down,${SERVERS})
ALL-CONFIGURE = $(patsubst %,%.configure,${SERVERS})

demo: all upload_demo prompt

all: ubuntu certificates ${SERVERS} checks

allup: ${ALL-UP}
festivals%.up:
	${MAKE} -C $(basename $@) up
	sleep 5

alldown: ${ALL-DOWN}
festivals%.down:
	${MAKE} -C $(basename $@) down

allservers: ${ALL-CONFIGURE}
festivals%.configure:
	${MAKE} -C $(basename $@) server
