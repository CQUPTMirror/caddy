#!/bin/bash

set -e

plugin_urls_file=$(./get_plugins.sh)
trap "rm $plugin_urls_file" EXIT
caddy_version=$(./get_caddy_version.sh)

declare -a plugin_urls
while IFS= read -r url; do
    echo "detected plugin url: " $url
    plugin_urls+=("$url")
done < $plugin_urls_file


plugin_cmd=""
for url in "${plugin_urls[@]}";do
    plugin_cmd+=" --with $url"
done

build_cmd=$(echo xcaddy build $caddy_version $plugin_cmd)
echo "build_cmd: $build_cmd"

# we use distroless image, so static is needed.
export CGO_ENABLED=0
eval "$build_cmd"