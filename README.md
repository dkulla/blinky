[![Code Climate](https://codeclimate.com/github/bguest/blinky.png)](https://codeclimate.com/github/bguest/blinky) [![Build Status](https://travis-ci.org/bguest/blinky.png?branch=master)](https://travis-ci.org/bguest/blinky) [![Coverage Status](https://coveralls.io/repos/bguest/blinky/badge.png)](https://coveralls.io/r/bguest/blinky) [![Dependency Status](https://gemnasium.com/bguest/blinky.png)](https://gemnasium.com/bguest/blinky)

#About

This is the server side application used to control the 2014 Burning Man project "Segment 16". The server side application is a Rails 4 application that runs on nginx and thin. The application runs on a Raspberry Pi. The Raspberry Pi sends SPI signals to a string of WS2801 addressable multi colored LEDs. CAD Designs will be opensource as well as soon as the become available.

Pictures of the project: https://www.facebook.com/media/set/?set=a.10101747777027690.1073741833.6906203&type=1&l=32b286d4ba

The goal is to build between 10 and 20 of these huge 16 segment displays. When they are hooked together, anyone with a phone or computer can log into the supplied wireless network go to a website and submit phrases to be displayed on the sign. There will also be an iphone app that you can download to control the sign.

#Contact
benguest@gmail.com

#Raspberry Pi

## Connections

| RaspberryPi  | Lead Wire | SH - 3535 -  WS2801 | 5V WS2801-16P STRIP |
|:-------------|:----------|:--------------------|:--------------------|
| (Power)      | RED       | +12V - Red          | 5V       - Black    |
| CLK (Clock)  | BLACK     | CLK  - White        | CI -> CO - Green    |
| MOSI         | GREEN     | DAT  - Green        | DI -> DO - Red      |
| GND (Ground) | BLACK     | GND  - Blue         | GND      - Blue     |

## Setup

See RaspberryPi_Setup.md

## TODO

1. Add reset button next to sign that turns off all leds
2. Update running sign when update sign effects

### Notes

ssh pi@raspberrypi.local
sudo ifconfig <— ipaddress

cd `gem env gemdir`

ps -ef | grep thin
df -h  du                 # disk usage

sudo ./a.out

sudo shutdown -h now
