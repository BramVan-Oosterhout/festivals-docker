# Recurring make recipes in development

enter:
	docker exec -it ${APP} /bin/bash

rmapp:
	docker rm -f ${APP}

reup: rmapp up enter

reconfigure: server reup

