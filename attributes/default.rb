# register an OAuth application for GitHub
default['depot']['oauth']['client_id'] = nil
default['depot']['oauth']['client_secret'] = nil

# fqdn that can be resolved, ie depot.example.com
default['depot']['fqdn'] = node['fqdn'] || node.name
