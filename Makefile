

VERSION := $(shell grep -m 1 "version" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
NAME := $(shell grep -m 1 "name" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
DESC := $(shell grep -m 1 "desc" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
APPID := $(shell grep -m 1 "appId" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/",?//')
PORT := $(shell grep -m 1 "port" "./conf/config.default.json" | sed -E 's/^ *//;s/.*: *"//;s/[,]//;s/"port": ?//')

proto:
	mkdir ./proto/${NAME} || true
	protoc --eva_out=plugins=all:./proto/${NAME} -I=./proto ${NAME}.proto
	protoc --go_out=plugins=grpc:./proto/${NAME} -I=./proto ${NAME}.proto

client:
	mkdir ./proto/${name} || true
	protoc --eva_out=plugins=client:./proto/${name} -I=./proto ${name}.proto

.PHONY: proto

build:
	GOOS=linux GOARCH=amd64 go build -o ${NAME} main.go

local:
	make build
	docker build -f infra/common/Dockerfile -t ${APPID}:v${VERSION}  --build-arg ENV=local --build-arg PORT=${PORT} --build-arg NAME=${NAME}   .

test:
	make build
	docker build -f infra/common/Dockerfile --build-arg ENV=test --build-arg PORT=${PORT} --build-arg NAME=${NAME}  -t ${APPID}:v${VERSION}  .

add:
	git subtree add --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master --squash

pull:
	git subtree pull --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master --squash

push:
	git subtree push --prefix=infra/common https://github.com/Gitforxuyang/evaCommon.git master