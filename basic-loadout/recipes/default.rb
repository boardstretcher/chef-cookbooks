# Cookbook Name:: basic-loadout
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'basic-loadout::update'
include_recipe 'basic-loadout::packages'
include_recipe 'basic-loadout::configure'
