# frozen_string_literal: true

RSpec.describe 'airborne gem configuration' do
  it 'loads' do
    expect(Airborne.configuration.base_url).to eq 'http://example.com'
  end

  context HttpTestHelper do
    let(:base_url) { 'http://example.com' }
    let(:headers) { { 'Authorization' => 'Bearer token1234' } }

    it 'saves and restores the original configuration' do
      Airborne.configuration.base_url = base_url
      Airborne.configuration.headers = headers
      temp_http_config = {
        base_url: 'http://new.com',
        headers: { 'X-Header' => '1234' }
      }

      configure_http_requests(
        config_driver: Airborne.configuration,
        http_config: temp_http_config
      ) {}

      expect(Airborne.configuration.base_url).to eql(base_url)
      expect(Airborne.configuration.headers).to eql(headers)
    end

    it 'uses the provided config for the duration of the yielded block' do
      Airborne.configuration.base_url = base_url
      Airborne.configuration.headers = headers
      temp_config = {
        base_url: 'http://new.com',
        headers: { 'X-Header' => '1234' }
      }

      actual_temp_config = {}
      configure_http_requests(config_driver: Airborne.configuration, http_config: temp_config) do
        actual_temp_config[:base_url] = Airborne.configuration.base_url
        actual_temp_config[:headers] = Airborne.configuration.headers
      end

      expect(temp_config).to eql(actual_temp_config)
    end
  end
end
