#
# Cookbook Name:: depot
# Recipe:: default
#
# The MIT License (MIT)
#
# Author:: Ben Dang
# Author:: Joshua Timberman <joshua@chef.io>
#
# Copyright (c) 2016 Ben Dang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

group 'hab'

user 'hab' do
  group 'hab'
end

hab_install [cookbook_name, recipe_name].join('::')

%w(hab-sup redis builder-router builder-sessionsrv hab-builder-vault builder-api builder-api-proxy).each do |pkg|
  hab_package "core/#{pkg}"
end

log 'oauth-warn' do
  message "Github OAuth client id and secret are not set! Users will be unable to log into Habitat Depot '#{node['depot']['fqdn']}'"
  level :warn
  only_if { node['depot']['oauth']['client_id'].nil? && node['depot']['oauth']['client_secret'].nil? }
end

# setup builder-api
directory '/hab/svc/builder-api/config' do
  recursive true
end

template '/hab/svc/builder-api/user.toml' do
  source 'builder-api-user.toml.erb'
  variables(
    oauth: node['depot']['oauth'],
    user_toml: node['depot']['user_toml']
  )
  sensitive true
end

# setup builder-sessionsrv
directory '/hab/svc/builder-sessionsrv' do
  recursive true
end

template '/hab/svc/builder-sessionsrv/user.toml' do
  source 'builder-sessionsrv-user.toml.erb'
  variables oauth: node['depot']['oauth']
  sensitive true
end

hab_service 'core/redis' do
  permanent_peer true
  listen_http '0.0.0.0:9631'
  listen_gossip '0.0.0.0:9631'
  service_group 'database'
  action :load
end

hab_service 'core/builder-router' do
  permanent_peer true
  listen_http '0.0.0.0:9630'
  listen_gossip '0.0.0.0:9639'
  service_group 'router'
  action :load
end

hab_service 'core/builder-sessionsrv' do
  permanent_peer true
  listen_http '0.0.0.0:9629'
  listen_gossip '0.0.0.0:9640'
  bind %w( database:redis.private router:builder-router.private)
  action :load
  subscribes :restart, 'template[/hab/svc/builder-sessionsrv/user.toml]'
end

hab_service 'core/hab-builder-vault' do
  permanent_peer true
  listen_http '0.0.0.0:9628'
  listen_gossip '0.0.0.0:9641'
  bind %w( database:redis.private router:builder-router.private)
  action :load
end

hab_service 'core/builder-api' do
  permanent_peer true
  listen_http '0.0.0.0:9627'
  listen_gossip '0.0.0.0:9642'
  bind %w( database:redis.private router:builder-router.private)
  action :load
  subscribes :restart, 'template[/hab/svc/builder-api/user.toml]'
end

hab_service 'core/builder-api-proxy' do
  permanent_peer true
  listen_http '0.0.0.0:9626'
  listen_gossip '0.0.0.0:9643'
  bind 'router:builder-router.private'
  action :load
end
