SHELL = /usr/bin/env bash

.PHONY: image
image:
	docker build -t nixrunner - < Dockerfile
