# # encoding: utf-8

# Inspec test for recipe depot::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

unless os.windows?
  describe user('hab') do
    it { should exist }
    its('group') { should eq 'hab' }
  end

  describe group('hab') do
    it { should exist }
  end
end

describe file('/bin/hab') do
  it { should be_executable }
  it { should be_symlink }
end

describe file('/bin/hab-director') do
  it { should be_executable }
  it { should be_symlink }
end

describe file('/hab/etc/director') do
  it { should be_directory }
end

describe file('/hab/svc/hab-builder-api') do
  it { should be_directory }
end

describe file('/hab/svc/hab-builder-api/config') do
  it { should be_directory }
end

describe file('/hab/svc/hab-builder-sessionsrv') do
  it { should be_directory }
end

describe port(80) do
  it { should_not be_listening }
  skip 'This is an example test, replace with your own test.'
end
