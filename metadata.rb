name 'depot'
maintainer 'Ben Dang'
maintainer_email 'me@bdang.it'
license 'MIT'
description 'Installs/Configures Habitat Depot'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

depends 'habitat', '~> 0.3.0'

issues_url 'https://github.com/bdangit/chef-depot/issues' if respond_to?(:issues_url)
source_url 'https://github.com/bdangit/chef-depot' if respond_to?(:source_url)

# Note: "habitat" resources require this version
chef_version '>= 12.11'
