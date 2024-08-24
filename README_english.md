# Caddy

CI repository，basing mirror site requirements of function, performance, scenerio, customizes and package caddy. It adds some useful plugins and parameters optimization.

CI configuration is automatically generated basing on the below section, so please keep below format stable.

## Modification Content

### Based caddy version

`v2.8.4`

### Plugins

|       name        | operation |                                            description                                                        |                      url                      |
|:-----------------:|:---------:|:-------------------------------------------------------------------------------------------------------------:|:---------------------------------------------:|
| caddy-logger-loki |    add    | log.writer plugin able to send log directly to loki without promtail help. This reduce unnecessary contaienrs | https://github.com/sujoshua/caddy-logger-loki | 

### Images

1. Using distroless base image and multi-stage build to reduce image size.
2. Change default cmd to `caddy run --config /etc/frontConfig`, to fit kubesync default config.