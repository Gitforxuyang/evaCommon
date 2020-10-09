
FROM alpine:3.10

RUN apk --update add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

RUN mkdir -p /app
# 以上部分可以弄成一个通用基础镜像

WORKDIR /app

##暴露端口
EXPOSE ${PORT}

ENV ENV=${ENV}

COPY conf/config.*.json /app/conf/
COPY ${NAME} /app/${NAME}

#最终运行docker的命令
ENTRYPOINT  ["./${NAME}"]