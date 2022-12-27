#!/bin/sh -e

alias dokku='ssh -t dokku@moochee.us'

echo "Deploy new version"
if dokku apps:exists website; then
    dokku apps:destroy website --force
fi
dokku apps:create website
dokku certs:add website /home/dokku/server.crt /home/dokku/server.key
dokku proxy:ports-set website http:80:8080 https:443:8080
dokku nginx:set website proxy-read-timeout 180m

git remote add dokku dokku@moochee.us:website || git remote set-url dokku dokku@moochee.us:website
git push dokku main

echo "Maping public route"
dokku domains:add website moochee.us
dokku domains:add website www.moochee.us
