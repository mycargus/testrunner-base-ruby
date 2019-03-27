# frozen_string_literal: true

# https://github.com/NoRedInk/rspec-retry

require 'rspec/retry'

RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry = true

  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true

  # retry up to n times (total of n+1 attempts)
  n = ENV.fetch('NUM_RETRY_ATTEMPTS', 1).to_i
  config.around :each do |ex|
    ex.run_with_retry retry: (n + 1)
  end
end
