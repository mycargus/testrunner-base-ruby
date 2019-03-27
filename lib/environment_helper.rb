# frozen_string_literal: true

module EnvironmentHelper
  def with_environment(keys, &block)
    # https://github.com/thoughtbot/climate_control#usage
    ClimateControl.modify(keys, &block)
  end
end
