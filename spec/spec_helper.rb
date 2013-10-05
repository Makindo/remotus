require "coveralls"
Coveralls.wear! do
  add_filter "/spec/"
end
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Rails.backtrace_cleaner.remove_silencers!
require "pry"
require "rspec"
require "vcr"
require "webmock/rspec"
require "mock_redis"
require "remotus"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

REDIS = MockRedis.new
