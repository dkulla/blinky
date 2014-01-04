[![Code Climate](https://codeclimate.com/github/bguest/blinky.png)](https://codeclimate.com/github/bguest/blinky) [![Build Status](https://travis-ci.org/bguest/blinky.png?branch=master)](https://travis-ci.org/bguest/blinky)

#About

This is the server side application used to control the 2014 Burning Man project "Segment 16". The server side application is a Rails 4 application that runs on nginx and thin. The application runs on a Raspberry Pi. The Raspberry Pi sends SPI signals to a string of WS2801 addressable multi colored LEDs. CAD Designs will be opensource as well as soon as the become available.

Pictures of the project: https://www.facebook.com/media/set/?set=a.10101747777027690.1073741833.6906203&type=1&l=32b286d4ba

The goal is to build between 10 and 20 of these huge 16 segment displays. When they are hooked together, anyone with a phone or computer can log into the supplied wireless network go to a website and submit phrases to be displayed on the sign. There will also be an iphone app that you can download to control the sign.

#Contact
benguest@gmail.com

#Raspberry Pi

The following is a bunch of stuff needed to configure your raspberry pi with nginx and thin so that it can run a web server

ssh pi@raspberrypi.local
sudo ifconfig <— ipaddress

source /home/pi/.rvm/scripts/rvm

cd `gem env gemdir`

Notes:

nano /etc/nginx/sites-available/blinky

upstream blinky {
  server 127.0.0.1:3000;
}
server {
  listen   80;
  server_name .raspberrypi.local;

  access_log /var/www/blinky/current/log/access.log;
  error_log  /var/www/blinky/current/log/error.log;
  root       /var/www/blinky/current;
  index      index.html;

  location / {
    proxy_set_header  X-Real-IP  $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  Host $http_host;
    proxy_redirect  off;
    try_files /system/maintenance.html $uri $uri/index.html $uri.html @ruby;
  }

  location ~ ^/(assets)/  {
    root /var/www/blinky/current/public;
    gzip_static off;
    expires max;
    add_header Cache-Control public;
    # access_log /dev/null;
  }

  location @ruby {
    proxy_pass http://0.0.0.0:3000;
  }
}

ln -nfs /etc/nginx/sites-available/blinky /etc/nginx/sites-enabled/blinky

thin config -C /etc/thin/blinky -c /var/www/blinky/current --servers 1 -e production

bundle exec /etc/init.d/thin restart
sudo /etc/init.d/nginx reload
sudo /etc/init.d/nginx restart

ps -ef | grep thin
df -h  du                 # disk usage

cat ~/.ssh/id_rsa.pub | ssh root@raspberrypi.local "mkdir .ssh;cat >> .ssh/authorized_keys"

chgrp -R dialout /sys/class/gpio
sudo chmod -R g+rw /sys/class/gpio

/usr/local/rvm/gems/ruby-2.0.0-p247/bin:/usr/local/rvm/gems/ruby-2.0.0-p247@global/bin:/usr/local/rvm/rubies/ruby-2.0.0-p247/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11

sudo ./a.out

sudo shutdown