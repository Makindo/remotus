#!/usr/bin/env ruby
source "https://rubygems.org/"

# Specify your gem"s dependencies in remotus.gemspec
gemspec

gem "gnip", "~> 0.1.0", git: "https://github.com/tylermorgan86/gnip"

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
