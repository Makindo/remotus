#!/usr/bin/env ruby
source "https://rubygems.org/"

# Specify your gem"s dependencies in remote.gemspec
gemspec

group :development, :test do
  gem "pry"
  gem "sqlite3"
end

group :development do
  gem "yard"
  gem "kramdown"
end

group :test do
  gem "rspec"
  gem "coveralls"
  gem "vcr"
  gem "webmock", "< 1.12"
  gem "mock_redis"
end
