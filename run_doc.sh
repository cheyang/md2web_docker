#!/bin/sh
#
# run this script to generate doc into a bootstrap style web page,
# and put it into the nginx server.
htmlDir=/usr/share/nginx/html

# step 1: generate html
cd /docs
find . -name "*.md" -exec nodejs \
node_modules/markdown2bootstrap/markdown2bootstrap.js \
'{}' -h --html --outputdir "${htmlDir}" \;

#cp "${myDir}/../doc/node_modules/markdown2bootstrap/bootstrap" "${htmlDir}/" -rf

# step 2: start nginx
nginx -g daemon off
