name 'test'
maintainer 'Ben Dang'
maintainer_email 'me@bdang.it'
license 'MIT'
source_url 'https://github.com/bdangit/chef-depot'
issues_url 'https://github.com/bdangit/chef-depot/issues'
description 'test'
long_description 'test'
version '0.0.1'

depends 'habitat'

chef_version '>= 12.0.3' if respond_to?(:chef_version)
