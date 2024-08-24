FROM golang:1.23.0-bookworm AS builder
 

# 是否开启go构建代理，如果在本机构建，这可能有用
ARG ENABLE_MIRROR=false
RUN if [ ${ENABLE_MIRROR} = true ];then \
        go env -w GOPROXY=https://goproxy.cn,direct; \
    fi
    
# 添加 xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build

COPY . /build/

RUN ./build.sh


FROM gcr.io/distroless/static-debian12

WORKDIR /caddy 

COPY --from=builder /build/caddy /usr/bin/caddy


EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

CMD ["caddy", "run", "--config", "/etc/frontConfig"]

