#
# Cookbook Name:: depot
# Spec:: default
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

require 'spec_helper'

describe 'depot::default' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: '16.04'
    )
    runner.converge(described_recipe)
  end

  it 'creates hab group' do
    expect(chef_run).to create_group('hab')
  end

  it 'creates hab user' do
    expect(chef_run).to create_user('hab').with(
      group: 'hab'
    )
  end

  it 'creates hab-director binlink' do
    expect(chef_run).to run_execute('hab pkg binlink core/hab-director hab-director')
  end

  it 'creates /hab/etc/director' do
    expect(chef_run).to create_directory('/hab/etc/director')
  end

  it 'creates /hab/svc/hab-builder-api/config' do
    expect(chef_run).to create_directory('/hab/svc/hab-builder-api/config')
  end

  it 'creates /hab/svc/hab-builder-sessionsrv' do
    expect(chef_run).to create_directory('/hab/svc/hab-builder-sessionsrv')
  end
end
