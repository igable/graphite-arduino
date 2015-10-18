Fimafeng Vagrant Development environment
========================================

This repository contains the vagrant setup for the FImafeng development environment.


To get going do:

    git clone git@github.com:roguegeer/fimafeng-vagrant.git
    cd fimafeng-vagrant

The main recipe that controls the execution of this chef provisioning is:

[cookbooks/fimafeng/recipe/default.rb](cookbooks/fimafeng/recipe/default.rb)

Progress that is made so far is:

- configure graphite from from ubuntu packages
- download and configure statsd from source
- connect those together

Right now you have to run statsd from the console by doing the following

    vagrant ssh
    cd /opt/statsd/src
    nodejs statsd.js /etc/statsd/statsdConfig.js

You can visit the graphite interface from:

http://localhost:9124

Todos:

- make will password for graphite work properly (chef configuration)
- 