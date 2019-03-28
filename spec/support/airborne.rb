# frozen_string_literal: true

# https://github.com/brooklynDev/airborne#configuration

Airborne.configure do |config|
  config.base_url = nil
  config.include HttpTestHelper
end
