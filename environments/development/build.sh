#!/usr/bin/env sh

script_path="$0"
env_dir="$(dirname $script_path)"
cd "$env_dir"
cd ../../

docker run --name="nginx-proxy" --restart=always --userns="host" -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy || true
docker network create wordpress || true
docker network connect wordpress nginx-proxy || true

cp environments/development/docker-compose.development.yml ./docker-compose.yml
cp environments/development/wp-config-sample.php wp-config.php

docker-compose build

docker-compose up -d
