# frozen_string_literal: true

require 'spec_helper'
require 'shared_spec'

gem_path = '/usr/local/bin'
check_name = 'check-log.rb'
check = "#{gem_path}/#{check_name}"
log_file = "#{File.dirname(__FILE__)}/test.log"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command(check.to_s) do
  it 'fails due to missing required parameters' do
    expect(subject.exit_status).to eq 2
    expect(subject.stdout).to match(/You must supply -q PAT!/)
  end
end

describe command("#{check} -q anything -f /dev/null") do
  it 'returns ok' do
    expect(subject.exit_status).to eq 0
    expect(subject.stdout).to match(/CheckLog OK: 0 warnings, 0 criticals for pattern anything./)
  end
end

describe command("#{check} -q error -f #{log_file}") do
  it 'returns critical' do
    expect(subject.exit_status).to eq 2
    expect(subject.stdout).to match(/CheckLog CRITICAL: 0 warnings, 1 criticals for pattern error./)
  end
end

describe command("#{check} --warn-only --warn 1 -q error -f #{log_file}") do
  before do
    `rm -rf /var/cache/check-log/`
  end
  it 'returns warning' do
    expect(subject.exit_status).to eq 1
    expect(subject.stdout).to match(/CheckLog WARNING: 1 warnings, 0 criticals for pattern error./)
  end
end
