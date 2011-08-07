#
# Cookbook Name:: boxee
# Recipe:: default
#
# Copyright 2011, Andrew Reusch
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/boxee.deb" do
  source node[:boxee_dpkg_url]
  checksum node[:boxee_dpkg_checksum]
  mode "0644"
  backup false
  action :create
end

package "gdebi-core" do
  action :install
end

script "install boxee" do
  not_if "dpkg -l boxee"
  interpreter "bash"
  user "root"
  code "gdebi -n #{Chef::Config[:file_cache_path]}/boxee.deb"
  action :run
end
