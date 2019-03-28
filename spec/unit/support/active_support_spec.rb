# frozen_string_literal: true

RSpec.describe 'activesupport gem configuration' do
  it 'loads active_support/core_ext' do
    expect([].blank?).to be_truthy
  end
end
