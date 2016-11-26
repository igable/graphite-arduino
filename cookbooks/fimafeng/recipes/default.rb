#
# Cookbook Name:: fimafeng
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# built from this repo
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-graphite-on-an-ubuntu-14-04-server
#
# Note: linux-image-extra-virtual is only required in the vagrant instance
#       handle this better in the future
%w{graphite-web graphite-carbon apache2 libapache2-mod-wsgi postgresql libpq-dev python-psycopg2 python-pip linux-image-extra-virtual minicom nodejs git}.each do |pkg|
    package pkg do
        action :install
    end
end


#
# Serial port config
#
cookbook_file '/etc/minicom/minirc.dfl' do
	owner 'root'
	mode '644'
	action :create
end


#
# Graphite and conbon config
#
cookbook_file '/etc/default/graphite-carbon' do
	owner 'root'
	mode '0644'
	action :create
end

cookbook_file '/etc/carbon/carbon.conf' do
	owner 'root'
	mode '0644'
	action :create
end

cookbook_file '/etc/carbon/storage-schemas.conf' do
	owner 'root'
	mode '0644'
	action :create
end

cookbook_file '/etc/carbon/storage-aggregation.conf' do
	owner 'root'
	mode '0644'
end

cookbook_file '/var/lib/graphite/create-db.sql' do
	owner 'root'
	mode '0644'
	action :create
	notifies :run, 'execute[postgres-create]'
end

execute 'postgres-create' do
	command "psql -f /var/lib/graphite/create-db.sql"
	user 'postgres'
	action :nothing
end

cookbook_file '/etc/graphite/local_settings.py' do
	owner 'root'
	mode '0644'
	action :create
	notifies :run, 'execute[graphite-create-db]'
end

execute 'graphite-create-db' do
	command "graphite-manage syncdb --noinput"
	action :nothing
end

cookbook_file '/var/lib/graphite/initial-users.json' do
	owner 'root'
	mode '0644'
	action :create
	notifies :run, 'execute[create-users]'
end

execute 'create-users' do
	command "graphite-manage loaddata /var/lib/graphite/initial-users.json"
	action :nothing
end

cookbook_file '/etc/apache2/sites-available/apache2-graphite.conf' do
	owner 'root'
	mode '0644'
	action :create
end

link '/etc/apache2/sites-enabled/apache2-graphite.conf' do
	to '/etc/apache2/sites-available/apache2-graphite.conf'
end

link '/etc/apache2/sites-enabled/000-default.conf' do
	to '/etc/apache2/sites-available/000-default.conf'
	action :delete
end



#
# Restart services
#
service 'carbon-cache' do
	action [ :enable, :restart ]
end

service 'apache2' do
	action [ :enable, :restart ]
end


#
# Development environment
#
execute 'python-virtualenv-config' do
  command 'pip install virtualenv statsd'
  action :run
end

#
# StatsD confgiration
#
directory '/opt/statsd/src' do
	recursive true
	action :create
end

git '/opt/statsd/src' do
  repository 'https://github.com/etsy/statsd.git'
  revision 'master'
  action :sync
end

directory '/etc/statsd' do
	recursive true
	action :create
end

cookbook_file '/etc/statsd/statsdConfig.js' do
	owner 'root'
	mode '0644'
end



