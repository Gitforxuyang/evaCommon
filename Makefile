

VERSION := $(shell grep -m 1 "version" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
NAME := $(shell grep -m 1 "name" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
DESC := $(shell grep -m 1 "desc" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
APPID := $(shell grep -m 1 "appId" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
PORT := $(shell grep -m 1 "port" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')

proto:
	mkdir ./proto/evaDemo || true
	protoc --eva_out=plugins=all:./proto/${NAME} -I=./proto ${NAME}.proto
	protoc --go_out=plugins=grpc:./proto/${NAME} -I=./proto ${NAME}.proto

.PHONY: proto

build:
	GOOS=linux GOARCH=amd64 go build -o evaDemo main.go

local:
	make build
	docker build -t ${APPID}:v${VERSION} --build-arg ENV=local PORT=${PORT} NAME=${NAME} .

test:
	make build
	docker build -t ${APPID}:v${VERSION} --build-arg ENV=test PORT=${PORT} NAME=${NAME} .

add:
	git subtree add --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master --squash

pull:
	git subtree pull --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master --squash

push:
	git subtree push --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master