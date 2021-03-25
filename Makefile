SHELL = /usr/bin/env bash


.PHONY: install
install: image
	./config.sh


.PHONY: image
image:
	docker build -t nixrunner \
		--build-arg USER_ID=${shell id --user} \
		--build-arg GROUP_ID=${shell id --group} \
		- < Dockerfile


.PHONY: clean
clean:
	rm -rf action-runner/
	mkdir action-runner
	rm -f ssh/known_hosts
	rm -rf work/*
