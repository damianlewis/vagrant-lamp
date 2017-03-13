#!/usr/bin/env bash

HOST=$1
ROOT=$2
PHP_VER=$3

mkdir -p /var/log/nginx/${HOST}

block="server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root $ROOT;

    index index.html index.htm index.php;

    server_name $HOST www.$HOST;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    access_log off;
    error_log  /var/log/nginx/$HOST/error.log error;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        fastcgi_pass unix:/run/php/php$PHP_VER-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}"

echo "$block" > "/etc/nginx/sites-available/$HOST"

ln -fs "/etc/nginx/sites-available/$HOST" "/etc/nginx/sites-enabled/$HOST"
rm /etc/nginx/sites-enabled/default
systemctl restart nginx > /dev/null 2>&1