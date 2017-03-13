Graphite Arduino Vagrant Development environment
================================================

This repository contains the [Vagrant](https://www.vagrantup.com/) configuration for graphite and 
configuration for connecting an arduino development board via USB. 


Getting Started
---------------

    git clone git@github.com:igable/graphite-arduino.git
    cd graphite-arduino
    vagrant up

Progress that is made so far is:

- configure graphite from from ubuntu packages
- download and configure statsd from source
- connect those together

Right now you have to run statsd from the console by doing the following

    vagrant ssh
    cd /opt/statsd/src
    nodejs statsd.js /etc/statsd/statsdConfig.js

You can visit the graphite interface from:

[http://localhost:9124](http://localhost:9124)


Serial Port Configuration
-------------------------

When pluging in the Arduno the serial port device comes up at `/dev/ttyACM0`. The Arduino board has:

    vendorid = 0x2341
    productid = 0x003d

You can get information about the USB devices with:

    lsusb


Vagrant and Chef
----------------

The [Vagrantfile](Vagrantfile) defines how vagrant is configured for this vagrant box. 

The main recipe that controls the execution of this chef provisioning is:

[cookbooks/graphite-arduino/recipes/default.rb](cookbooks/graphite-arduino/recipes/default.rb)

Once a change has been made to the recipes you can start a chef run by doing:

    vagrant provision

