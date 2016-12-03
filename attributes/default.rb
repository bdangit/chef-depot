# register an OAuth application for GitHub
default['depot']['oauth']['client_id'] = 'blah'
default['depot']['oauth']['client_secret'] = 'secret'

# fqdn that can be resolved, ie depot.example.com
# note: if not filled in, this value will be set to do `node.name`
default['depot']['fqdn'] = nil
