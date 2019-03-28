# frozen_string_literal: true

RSpec.describe 'test-queue-split gem configuration' do
  it 'distributes the tests for optimal speed' do
    expect(ENV['TEST_QUEUE_SPLIT_GROUPS']).to eql 'false'
  end

  it 'records test run statistics' do
    expect(ENV['TEST_QUEUE_STATS']).to eql 'tmp/.test_queue_stats'
  end
end
