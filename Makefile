BIN_PATH=${HOME}/.local/share/virtualenvs/$(shell basename $(shell pwd))/bin

all: build

build:
	@docker build --tag=rajalokan/apt-cacher-ng .

run:
	${BIN_PATH}/docker-compose up -d

log:
	@docker exec -it apt-cacher-ng tail -f /var/log/apt-cacher-ng/apt-cacher.log

stop:
	@docker-compose stop

ssh:
	@docker exec -it apt-cacher-ng bash
