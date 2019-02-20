#!/bin/sh
sleep 3
/usr/bin/aws s3 mv /var/www/newsystems/$1/ s3://staging.newsystems/$1/ --acl public-read --recursive

