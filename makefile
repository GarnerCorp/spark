.PHONY: build-run-production run-production build-run-just-master deploy-just-master build-production build-production tag-production publish-production build-tag-deploy reset-local stop-local
PROJECT_NAME=GARNER-SPARK
IMAGE_VERSION=latest
DOCKER_LOCATION=./garner/docker
GARNER_LOCATION=./garner

build-run-production: build-production run-production

run-production:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} up;

build-run-just-master:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-master; \
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} up spark-master;

deploy-just-master:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-master;  \
	docker tag spark-master:latest gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION};

build-production:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-hive; \
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-master;  \
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-worker-1;

tag-production:
	docker tag spark-worker:latest gcr.io/helical-crowbar-220917/spark-worker:${IMAGE_VERSION}; \
	docker tag spark-hive:latest gcr.io/helical-crowbar-220917/spark-hive:${IMAGE_VERSION}; \
	docker tag spark-master:latest gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION};

publish-production:
	docker push gcr.io/helical-crowbar-220917/spark-worker:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-hive:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION};

build-tag-deploy: build-production tag-production publish-production

reset-local:
	/bin/zsh ${GARNER_LOCATION}/scripts/reset_hive_local.sh;

stop-local:
	/bin/zsh ${GARNER_LOCATION}/scripts/stop_all_custom.sh;

make-runnable-distribution:
	/bin/zsh  ${GARNER_LOCATION}/scripts/make_distribution.sh;



package-master:
	/bin/zsh ${GARNER_LOCATION}/scripts/build_master.sh;