#
# Cookbook Name:: okb-legacy
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'okb-legacy::install-php'
include_recipe 'okb-legacy::apache2'

# TODO
# - install RabbitMQ?
# - configure Apache site for 1kb site
