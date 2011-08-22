#
# Cookbook Name:: constitution
# Recipe:: default
#
# Copyright 2011 Andrew Reusch
#
# All rights reserved - Do Not Redistribute
#

require 'erb'

if node[:constitution][:managed_users].respond_to?('each')
  node[:constitution][:managed_users].each do | user |
    config_url = nil
    if user.is_a?(Hash)
      user_name = user[:user]
      if user.has_key?(:config_url)
        config_url = user[:config_url]
      end
    else
      user_name = user
    end

    if config_url.nil?
      config_erb = ERB.new(node[:constitution][:default_config_root])
      config_url = config_erb.result binding
    end

    puts "CCU? #{respond_to?('constitution_configured_user')}"
    puts "CCCU? #{respond_to?('constitution_constitution_configured_user')}"
    constitution_configured_user user_name do
      puts self
      puts respond_to?('configuration_git_url')
#      configuration_git_url config_url
      action :create
    end
  end
end
