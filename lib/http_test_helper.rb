# frozen_string_literal: true

module HttpTestHelper
  def configure_http_requests(config_driver: Airborne.configuration, http_config: {})
    raise ArgumentError unless block_given?

    previous_config = {
      base_url: config_driver.base_url,
      headers: config_driver.headers
    }

    config_driver.base_url = http_config.fetch(:base_url)
    config_driver.headers = http_config.fetch(:headers)

    yield

    config_driver.base_url = previous_config.fetch(:base_url)
    config_driver.headers  = previous_config.fetch(:headers)
  end
end
