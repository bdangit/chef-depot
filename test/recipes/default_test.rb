%w(redis hab-builder-router hab-builder-api hab-builder-vault hab-builder-sessionsrv builder-api-proxy).each do |svc|
  describe service(svc) do
    it { should be_running }
  end
end

describe file('/hab/svc/hab-builder-sessionsrv') do
  it { should be_directory }
end

describe port(80) do
  it { should be_listening }
end

describe http('http://192.168.96.31') do
  its('status') { should be 200 }
end

describe command('curl http://localhost:9627/services/hab-builder-api/default/health') do
  its('exit_status') { should be 0 }
end

# hab-builder-api has secrets configured
describe command('curl http://localhost:9627/services | jq ".[0].config.cfg.user.github.client_id"') do
  its('stdout') { should match(/^\"github_client_id\"$/) }
end

describe command('curl http://localhost:9627/services | jq ".[0].config.cfg.user.github.client_secret"') do
  its('stdout') { should match(/^\"github_client_secret\"$/) }
end

# hab-builder-sessionsrv has secrets configured
describe command('curl http://localhost:9629/services | jq ".[0].config.cfg.user.github.client_id"') do
  its('stdout') { should match(/^\"github_client_id\"$/) }
end

describe command('curl http://localhost:9629/services | jq ".[0].config.cfg.user.github.client_secret"') do
  its('stdout') { should match(/^\"github_client_secret\"$/) }
end
