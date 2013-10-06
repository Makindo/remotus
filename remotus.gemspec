# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remotus/version"

Gem::Specification.new do |spec|
  spec.name          = "remotus"
  spec.version       = Remotus::VERSION
  spec.authors       = ["Kurtis Rainbolt-Greene"]
  spec.email         = ["me@kurtisrainboltgreene.name"]
  spec.summary       = %q{The remote library for BlueBird}
  spec.description   = spec.summary
  spec.homepage      = "http://makindo.github.com/remotus"
  spec.license       = "MIT"

  spec.files         = Dir["{app,config,db,lib}/**/*"]
  spec.executables   = Dir["bin/**/*"].map! { |f| f.gsub(/bin\//, '') }
  spec.test_files    = Dir["test/**/*", "spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 4.0"
  spec.add_runtime_dependency "sidekiq", "~> 2.0"
  spec.add_runtime_dependency "twitter", "~> 4.6"
  spec.add_runtime_dependency "koala", "~> 1.6"
  spec.add_runtime_dependency "skittles", "~> 0.6"
  spec.add_runtime_dependency "pipl-api", "~> 3.0"
  spec.add_runtime_dependency "geocoder", "~> 1.1"
  spec.add_runtime_dependency "astruct", "~> 2.11"
  spec.add_runtime_dependency "redis", "~> 3.0"
  spec.add_runtime_dependency "redis-rails", "~> 4.0"
end
