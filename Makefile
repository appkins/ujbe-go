.PHONY: docker-build

VERSION := $(shell grep "const Version " bin/api/version.go | sed -E 's/.*"(.+)"$$/\1/')

default: test

help:
	@echo 'Helper commands for ujbe'
	@echo
	@echo 'Usage'
	@echo '			make build									Build the API binary for current platform'
	@echo '			make get-deps								Fetch dependencies with Glide'
	@echo '			make migrate								Run SQL migrations'
	@echo '			make test										Runs all Go Tests'
	@echo '			make docker-build						Build a minimal docker image'
	@echo '			make clean									Cleans up anything created'
	@echo

build:
	@echo 'Building'
	go build bin/api -o bin/api/api

get-deps:
	@echo 'Fetching dependencies'
	glide install

docker-build:
	@echo 'Building github.com/kisamoto/ujbe:build'
	@echo
	docker build -t github.com/kisamoto/ujbe:build . -f Dockerfile.build
	@echo
	@echo 'Extracting api binary'
	@echo
	docker create --name extract github.com/kisamoto/ujbe:build
	docker cp extract:/go/src/github.com/kisamoto/ujbe/api ./api
	docker rm -f extract
	@echo
	@echo 'Building github.com/kisamoto/ujbe:latest'
	@echo
	docker build --no-cache -t github.com/kisamoto/ujbe:latest .
	@echo
	@echo 'Cleaning up'
	@echo
	rm ./api

migrate:
	@echo 'Migrating database'
	@echo

test:
	@echo 'Running tests'
	go test -cover

clean:
	@test ! -e bin/api/api || rm bin/api/api