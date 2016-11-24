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

# note: the origin 'my' is fictious. hab_service requires there to be an
#       origin, however, for this we are running hab-director and not a
#       specific application.
hab_service 'my/hab-depot' do
  unit_content(lazy do
    {
      'Unit' => {
        'Description' => 'Habitat Depot Server',
        'After' => 'network.target audit.service'
      },
      'Service' => {
        'Environment' => ['SSL_CERT_FILE=',
                          shell_out('/bin/hab pkg path core/cacerts').stdout.chomp,
                          '/ssl/cert.pem'
                         ].join(''),
        'ExecStart' => '/bin/hab-director start -c /hab/etc/director/config.toml',
        'Restart' => 'on-failure'
      }
    }
  end)
  action [:enable, :start]
end
