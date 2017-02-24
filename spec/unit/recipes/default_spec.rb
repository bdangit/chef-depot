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
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(
      platform: 'ubuntu',
      version: '16.04'
    ).converge(described_recipe)
  end

  it 'creates hab group' do
    expect(chef_run).to create_group('hab')
  end

  it 'creates hab user' do
    expect(chef_run).to create_user('hab').with(
      group: 'hab'
    )
  end

  it 'creates /hab/svc/hab-builder-api/config' do
    expect(chef_run).to create_directory('/hab/svc/hab-builder-api/config')
  end

  it 'creates /hab/svc/hab-builder-sessionsrv' do
    expect(chef_run).to create_directory('/hab/svc/hab-builder-sessionsrv')
  end

  context 'habitat depot services' do
    let(:api_service) { chef_run.hab_service('core/hab-builder-api') }
    let(:session_service){ chef_run.hab_service('core/hab-builder-sessionsrv') }

    %w{redis hab-builder-router hab-builder-sessionsrv hab-builder-vault hab-builder-api builder-api-proxy}.each do |svc|
      it "manages the hab_service #{svc}" do
        expect(chef_run).to enable_hab_service("core/#{svc}")
        expect(chef_run).to start_hab_service("core/#{svc}")
      end
    end

    it 'restarts hab-builder-api if its user config changes' do
      expect(api_service).to subscribe_to('template[/hab/svc/hab-builder-api/user.toml]')
    end

    it 'restarts hab-builder-sessionsrv if its user config changes' do
      expect(session_service).to subscribe_to('template[/hab/svc/hab-builder-sessionsrv/user.toml]')
    end
  end
end
