#
# Cookbook Name:: depot
# Recipe:: install
#
# The MIT License (MIT)
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

hab_install 'install habitat'
hab_package 'core/hab-sup'
hab_package 'core/hab-director'

execute 'hab pkg binlink core/hab-director hab-director' do
  not_if { ::File.exist? '/bin/hab-director' }
end

directory '/hab/etc/director' do
  recursive true
end

cookbook_file '/hab/etc/director/config.toml' do
  source 'director-config.toml'
end

directory '/hab/svc/hab-builder-api/config' do
  recursive true
end

template '/hab/svc/hab-builder-api/user.toml' do
  source 'hab-builder-api-user.toml.erb'
  variables(
    oauth_app_client_id: node['depot']['oauth']['client_id'],
    oauth_app_client_secret: node['depot']['oauth']['client_secret'],
    fqdn: node.name
  )
end

directory '/hab/svc/hab-builder-sessionsrv' do
  recursive true
end

template '/hab/svc/hab-builder-sessionsrv/user.toml' do
  source 'hab-builder-sessionsrv-user.toml.erb'
  variables(
    oauth_app_client_id: node['depot']['oauth']['client_id'],
    oauth_app_client_secret: node['depot']['oauth']['client_secret']
  )
end
