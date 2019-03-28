# frozen_string_literal: true

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

RSpec.configure do |config|
  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = 'tmp/examples.txt'

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random
  Kernel.srand config.seed

  config.tty = true
  config.color = true
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.warnings = false
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Tag all contract tests with :type => :contract
  config.define_derived_metadata(file_path: %r{/spec/contracts/}) do |metadata|
    metadata[:type] = :contract
  end

  # Tag all scenario tests with :type => :scenario
  config.define_derived_metadata(file_path: %r{/spec/scenarios/}) do |metadata|
    metadata[:type] = :scenario
  end

  # The following requires each *_spec.rb file inside the spec/contracts/
  # and spec/scenarios directories to create an http_config as follows:
  #
  # let(:http_config) { <config> }
  #
  %i[contract scenario].each do |type|
    config.around(:each, type: type) do |example|
      configure_http_requests(http_config: http_config) { example.run }
    end

    config.include HttpTestHelper, type: type
  end

  # All specs get these helpers:
  config.include EnvironmentHelper
end

# Silence output from pending examples in documentation formatter
module FormatterOverrides
  def example_pending(_empty); end

  def dump_pending(_empty); end
end

RSpec::Core::Formatters::DocumentationFormatter.prepend FormatterOverrides

# Silence output from pending examples in progress formatter
RSpec::Core::Formatters::ProgressFormatter.prepend FormatterOverrides
