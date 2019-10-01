#!/usr/bin/env bash

UNIXTIME=$(date +%s)

docker build -f Dockerfile.prod -t cloud.canister.io:5000/skoba/ujournal-web:build-$UNIXTIME .
docker push cloud.canister.io:5000/skoba/ujournal-web:build-$UNIXTIME

cd ./vueModules
docker build -f Dockerfile.prod -t cloud.canister.io:5000/skoba/ujournal-modules:build-$UNIXTIME .
docker push cloud.canister.io:5000/skoba/ujournal-modules:build-$UNIXTIME

cd ..
helm upgrade -i --set web.image.tag=build-$UNIXTIME --set modules.image.tag=build-$UNIXTIME --wait --namespace default ujournal ./chart
