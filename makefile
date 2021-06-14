.PHONY: build-run-production run-production build-run-just-master deploy-just-master build-production build-production tag-production publish-production build-tag-deploy reset-local stop-local

PROJECT_NAME=GARNER-SPARK
IMAGE_VERSION=latest
DOCKER_LOCATION=./garner/docker
GARNER_LOCATION=./garner

production-build-run: production-build production-run
production-build-tag-deploy: production-build production-tag production-publish

production-run:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} up;

production-build:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build --parallel spark-hive-admin spark-master spark-worker-1 ; \

production-tag:
	docker tag spark-worker:latest gcr.io/helical-crowbar-220917/spark-worker:${IMAGE_VERSION}; \
	docker tag spark-hive:latest gcr.io/helical-crowbar-220917/spark-hive:${IMAGE_VERSION}; \
	docker tag spark-master:latest gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION};

production-publish:
	docker push gcr.io/helical-crowbar-220917/spark-worker:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-hive:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-master:${IMAGE_VERSION};

local-reset:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} up -d spark-postgres-metastore; \
	/bin/zsh ${GARNER_LOCATION}/scripts/reset_hive_local.sh;

local-stop:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} down; \
	/bin/zsh ${GARNER_LOCATION}/scripts/stop_all_custom.sh;

postgres-build-tag:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-postgres-metastore-1;

postgres-build-tag-publish:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-postgres-metastore; \
	docker tag spark-postgres:latest gcr.io/helical-crowbar-220917/spark-postgres:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-postgres:${IMAGE_VERSION};

make-runnable-distribution:
	/bin/zsh  ${GARNER_LOCATION}/scripts/make_distribution.sh;

maintainer-build-tag-publish:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-maintainer; \
	docker tag spark-maintainer:latest gcr.io/helical-crowbar-220917/spark-maintainer:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-maintainer:${IMAGE_VERSION};

maintainer-build-tag:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-maintainer; \
	docker tag spark-maintainer:latest gcr.io/helical-crowbar-220917/spark-maintainer:${IMAGE_VERSION};

maintainer-base-build-tag-publish:
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-maintainer-base; \
	docker tag spark-maintainer-base:latest gcr.io/helical-crowbar-220917/spark-maintainer-base:${IMAGE_VERSION}; \
	docker push gcr.io/helical-crowbar-220917/spark-maintainer-base:${IMAGE_VERSION};

base-build-tag:
	/bin/zsh ${GARNER_LOCATION}/scripts/copy_files_in.sh; \	
	docker-compose -f ${DOCKER_LOCATION}/docker-compose-production.yml -p ${PROJECT_NAME} build spark-base; \
	docker tag spark-base:latest gcr.io/helical-crowbar-220917/spark-base:${IMAGE_VERSION};

base-build-tag-publish: base-build-tag
	docker push gcr.io/helical-crowbar-220917/spark-base:${IMAGE_VERSION};