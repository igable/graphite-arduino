#
# Cookbook Name:: fimafeng
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
# Note: linux-image-extra-virtual is only required in the vagrant instance
#       handle this better in the future
%w{libpq-dev python-psycopg2 python-pip linux-image-extra-virtual minicom git}.each do |pkg|
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
# Development environment
#
execute 'python-virtualenv-config' do
  command 'pip install virtualenv'
  action :run
end

#
# AWS IoT SDK 
#
execute 'install-python-aws-iot-sdk' do
  command 'pip install AWSIoTPythonSDK'
  action :run
end





