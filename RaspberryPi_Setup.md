# How to setup Raspberry Pi

This little guide should get you through setup and boot up of your
raspberry pi.

**Notes**:

+ These instructions assume that you are using a Macintosh computer to do the setup.
+ This assumes that you are familiar with running things from the command line, or
  your really good at following directions.
+ '$' implies Terminal Command line (you shouldn't enter $ just what follows)
+ '\>\>' implies irb Command line (you shouldn't enter >> just what follows)
+ When asked if you want to install things, you will always answer yes.

## What you will need

### Hardware

1. A Macintosh computer, sorry that's what I have.
1. A Raspberry Pi (get one from [sparkfun](https://www.sparkfun.com/products/11546))
2. Micro USB to USB ([Amazon][micro_usb])
2. 8 GB SD Card ([Amazon][sd_card])
3. SD Card Reader ([Amazon][card_reader])
4. Router connected to your Mac (wireless or otherwise)
5. Ethernet Cable

### Software

1. Copy of Occidentalis v0.2 ([Occidentalis][occidentalis])

## Steps

### A. Format the SD Card

2. Insert SD Card into the SD Card Reader and plug that into a USB slot on your mac.
2. Open the Disk Utility application.
3. Select the SD Card.
4. Select the Erase Tab.
5. Set the format to MS-DOS (FAT)
6. Set the name to something recognizable like RASP_PI
7. Click Erase... (and confirm if necessary)

### B. Install Occidentalis

1. Decompress occidentalis (usually by double clicking the zip you downloaded), you should have a file called Occidentalis_v02.img
2. Open up the Terminal.app (or whatever terminal you prefer)
3. Type `df -h` then return and you should see a line that looks something like

        /dev/disk4s1   7.4Gi  832Ki  7.4Gi     1%         0         0  100%   /Volumes/RASP_PI

4. Unmount that partition with `diskutil unmount /dev/disk4s1` where the `4s1` part comes from
   whatever you saw in the previous step you should see something like

        Volume RASP_PI on disk4s1 unmounted

   If you see something different you may need to run the previous command with `sudo`

5. Copy the occidentals image to the SD card.

   In the following command, substitute <path to> with the path to your copy of Occidentalis_v02.img and change <#> to the number of the disk from step 3

        sudo dd bs=1m if=<path to>/Occidentalis_v02.img of=/dev/rdisk<#>

   **WARNING** Be sure you know what you are doing here, if you screw up and enter the wrong disk number you could overwrite you whole hard drive.

6. Wait. It will take a second, but eventually you will see something like

        2479+1 records in
        2479+1 records out
        2600000000 bytes transferred in 323.754960 secs (8030765 bytes/sec)

### C. Boot up Raspberry Pi

1. Eject the Raspberry Pi SD Card.
2. Insert the SD Card in to the Pi.
3. Use the Micro USB to USB to connect the Raspberry Pi to a power source (your computer or USB power
   adapter)
3. Use the ethernet cable to connect your router to the Raspberry Pi
4. Wait a few minutes, There are a bunch of LEDs on the Raspberry Pi they should all be lit and
   blinking happily

### D. Setup User

1. ssh into the Raspberry Pi, In the terminal type

        ssh pi@raspberrypi.local

   The default password is `raspberry`

2. Change the user pi's default password, in ssh session, make the prompt look like

        pi@raspberrypi ~ $ passwd

   Enter the old default `raspberry` password followed twice by your new password as requested. Remember your new password or better yet use an application like 1Password to remember it for you

3. Change the root user password, similar to changing the pi user password except with `sudo passwd root`
4. Exit out of the current ssh session using `exit` and log back in as the root user using
   `ssh root@raspberrypi.local`
5. If Raspi-config doesn't launch immediately, launch it by typing `raspi-config` into the terminal
6. Use the arrow keys to select `expand_rootfs`, hit enter to resize the rootfs
7. Use the arrow keys to select `<finish>`, hit enter and then hit enter again to answer `<Yes>` to
   the prompt about rebooting.
8. Setup the correct locale, log back into the RaspberryPi using `$ ssh root@raspberrypi.local`

   Use `vi` or `nano` to edit `/ect/default/locale` make it look like:

        LANG=en_GB.UTF-8
        LANGUAGE=en_GB.UTF-8

### E. Add SSH Key to Pi (Optional but suggested)

At the command prompt enter the following two lines individually

    cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi.local 'mkdir .ssh; touch .ssh/authorized_keys; cat >> .ssh/authorized_keys'

    cat ~/.ssh/id_rsa.pub | ssh root@raspberrypi.local 'mkdir .ssh; touch .ssh/authorized_keys; cat >> .ssh/authorized_keys'

Follow prompts, the passwords requested are the passwords that you entered above

### F. Setup WiFi (optional)

ssh into raspberry pi (`ssh root@raspberrypi.local`) edit `/etc/network/interfaces` to include your network ssid and wifi-password

### G. Install Software: Ruby, RubyGems, Javascript, Thin, Nginx, PostgreSQL

Note: You can install ruby using rvm, but I don't recommend it as its kind of overkill
and you will likely run into problems later.

1. ssh into your Pi as root `ssh root@raspberrypi.local`
2. Install dependencies

        apt-get update
        apt-get install libreadline5-gplv2-dev libyaml-dev libssl-dev

2. Install Ruby, I'm using the latest version at the time of writing (2.1.1), however you can
   choose, whatever version you feel like by going to the [ruby-lang ftp site][ruby-lang-ftp]
   and finding the version you want to install.

        cd ~
        wget ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz
        gunzip ruby-2.1.1.tar.gz
        tar -xf ruby-2.1.1.tar
        rm ruby-2.1.1.tar
        cd ruby-2.1.1
        ./configure --prefix=/usr     # Takes long enough to grab a beer and maybe drink it.
        make                          # Takes a long time (~2 hours), go for a hike.
        make install                  # Drink another beer.

   Delete the source code to save space (optional, but recommended)

        cd ..
        rm -fR ruby-2.1.1

2. Check the ruby version and fire up irb to see if things are working

        $ ruby --version
        $ irb
        >> 2+2 #=> 4 ...

2. Install NodeJS (because we need a Javascript runtime for rails)

        apt-get install nodejs

2. Install PostgreSql

        apt-get install postgresql
        pg_createcluster 9.1 main --start
        apt-get install postgresql-server-dev-9.1

   Setup the database with a root user

        su - postgres
        psql template1

        CREATE USER root WITH PASSWORD 'your password';
        CREATE DATABASE blinky_production;
        GRANT ALL PRIVILEGES ON DATABASE blinky_production TO root;
        ALTER USER root WITH SUPERUSER CREATEDB;
        /q

        $ exit    # exit out of using postgres user

3. Install RubyGems and Bundler

        apt-get install rubygems
        echo "gem: --no-ri --no-rdoc" >> ~/.gemrc  # Don't install documentation
        gem install bundler

4. Install Thin

        gem install thin
        thin install
        /usr/sbin/update-rc.d -f thin defaults    # Start thin on boot
        thin config -C /etc/thin/blinky -c /var/www/blinky/current --servers 1 -e production

5. Install Nginx

        apt-get install nginx

   Edit the file at /etc/nginx/sites-available/blinky

        vi /etc/nginx/sites-available/blinky

   Or if you are uncomfortable with `vi` you can use `nano`

        nano /etc/nginx/sites-available/blinky

   Edit this file to look like

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

   Enable this configuration

        ln -nfs /etc/nginx/sites-available/blinky /etc/nginx/sites-enabled/blinky

7. Exit out of the RaspberryPi ssh session with `$ exit`

### H. Deploy Blinky

Use Capistrano 3 to deploy application **from your Mac's Terminal**

    $ cd <where ever you cloned this repo to>
    $ bundle exec cap production deploy

## Thanks / More Info

This guide wouldn't have been possible without the following resources

http://elinux.org/RPi_Ruby
http://creativepsyco.github.io/blog/2013/04/10/deploying-rails-on-nginx-and-thin/

[micro_usb]:http://www.amazon.com/Micro-USB-to-Cable/dp/B004GETLY2/
[sd_card]:http://www.amazon.com/Transcend-Class-Flash-Memory-TS8GSDHC10E/dp/B003VNKNEG/
[card_reader]:http://www.amazon.com/IOGEAR-MicroSD-Reader-Writer-GFR204SD/dp/B0046TJG1U/
[occidentalis]:http://learn.adafruit.com/adafruit-raspberry-pi-educational-linux-distro/occidentalis-v0-dot-2
[ruby-lang-ftp]:ftp://ftp.ruby-lang.org/pub/ruby/
