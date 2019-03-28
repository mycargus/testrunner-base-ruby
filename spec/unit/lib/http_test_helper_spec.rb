# frozen_string_literal: true

RSpec.describe HttpTestHelper do
  class Configuration
    attr_accessor :base_url, :headers

    def initialize(base_url:, headers:)
      @base_url = base_url
      @headers = headers
    end

    def full
      {
        base_url: @base_url,
        headers: @headers
      }
    end
  end

  class FakeConfigDriver
    attr_reader :configuration

    def initialize(config)
      @configuration = config
    end
  end

  let(:base_url) { 'http://example.com' }
  let(:headers) { { 'Authorization' => 'Bearer token1234' } }
  let(:fake_config_driver) do
    FakeConfigDriver.new(
      Configuration.new(base_url: base_url, headers: headers)
    )
  end

  it 'raises ArgumentError when no block is given' do
    expect { configure_http_requests(&nil) }.to raise_error(ArgumentError)
  end

  it 'raises KeyError when missing :base_url' do
    http_config = { headers: headers }
    expect { configure_http_requests(http_config: http_config) {} }.to(
      raise_error(KeyError, /:base_url/)
    )
  end

  it 'raises KeyError when missing :headers' do
    http_config = { base_url: base_url }
    expect { configure_http_requests(http_config: http_config) {} }.to(
      raise_error(KeyError, /:headers/)
    )
  end

  it 'saves and restores the original configuration' do
    temp_http_config = {
      base_url: 'http://new.com',
      headers: { 'X-Header' => '1234' }
    }

    configure_http_requests(
      config_driver: fake_config_driver.configuration,
      http_config: temp_http_config
    ) {}

    expect(fake_config_driver.configuration.base_url).to eql(base_url)
    expect(fake_config_driver.configuration.headers).to eql(headers)
  end

  it 'uses the provided config for the duration of the yielded block' do
    temp_http_config = {
      base_url: 'http://new.com',
      headers: { 'X-Header' => '1234' }
    }

    actual_temp_http_config = {}
    configure_http_requests(
      config_driver: fake_config_driver.configuration,
      http_config: temp_http_config
    ) do
      actual_temp_http_config[:base_url] = fake_config_driver.configuration.base_url
      actual_temp_http_config[:headers] = fake_config_driver.configuration.headers
    end

    expect(temp_http_config).to eql(actual_temp_http_config)
  end
end
