# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

# We need to load lib/ first so that *_spec.rb files can load them
# too without our having to explicitly require the lib in each spec file.
FileList.new('lib/**/*.rb')
        .map! { |file| "#{__dir__}/../#{file}" }
        .each { |file| require file }

# Load all gem configs
FileList.new('spec/support/**/*.rb')
        .map! { |file| "#{__dir__}/../#{file}" }
        .each { |file| require file }
