# register an OAuth application for GitHub
default['depot']['oauth'].tap do |oauth|
  oauth['client_id'] = nil
  oauth['client_secret'] = nil
end

default['depot']['user_toml'].tap do |user_toml|
  user_toml['app_url']         = "http://#{node['fqdn'] || node.name}/v1"
  user_toml['community_url']   = 'https://www.habitat.sh/community'
  user_toml['docs_url']        = 'https://www.habitat.sh/docs'
  user_toml['environment']     = 'private'
  user_toml['friends_only']    = false
  user_toml['source_code_url'] = 'https://github.com/habitat-sh/habitat'
  user_toml['www_url']         = 'https://www.habitat.sh'
  user_toml['tutorials_url']   = 'https://www.habitat.sh/tutorials'
end
