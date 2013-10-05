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

Twitter.configure do |config|
  config.consumer_key = "bbUHiFMjFhOkhial9izPg"
  config.consumer_secret = "ZkQwJbOMohFJF7tZqQLhvtLuju7DPgzhOn0Rdz3xiw"
  config.oauth_token = "55137522-Q1ihDmuaxkdYKxQaAjaQ8Z6ljo3lUPLP9gLhZo7Q1"
  config.oauth_token_secret = "Tt7YtdPft8PgyDH2E2KwFrU6MEInj6mCLreh1q43w"
end

REDIS = MockRedis.new
