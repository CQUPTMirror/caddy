# Caddy

[English](README_english.md)

CI仓库，根据镜像站实际的功能、性能、场景需求，定制化打包caddy。增加了一些有用的插件和参数优化。

CI的配置将根据下面的README生成，请保证下面的格式不变。

## 修改内容

### 基于的caddy版本

`v2.8.4`

### 插件

|名字|操作|描述|地址|
|:---:|:---:|:---:|:---:|
|caddy-logger-loki|add|log.writer插件，可以让caddy直接发送log给loki，而不需要promtail。这可以减少不必要的container|https://github.com/sujoshua/caddy-logger-loki|

### 镜像

1. 使用distroless镜像和多阶段构建，减少镜像体积。
2. 默认cmd更改为`caddy run --config /etc/frontConfig`，契合kubesync的默认设置。