#!/bin/sh -e

alias dokku='ssh -t dokku@moochee.us'

echo "Deploy new version"
if dokku apps:exists www; then
    dokku apps:destroy www --force
fi
dokku apps:create www
dokku certs:add www /home/dokku/server.crt /home/dokku/server.key
dokku proxy:ports-set www http:80:80 https:443:80

git remote add dokku dokku@moochee.us:www || git remote set-url dokku dokku@moochee.us:www
git push dokku main

echo "Maping public route"
dokku domains:add www moochee.us
