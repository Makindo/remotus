require "twitter"
require "koala"
require "sidekiq"
require "skittles"
require "pipl-api"
require "geocoder"
require "astruct"

module Remote

end

require_relative "remote/version"
require_relative "remote/engine"
require_relative "remote/data"
require_relative "remote/external"
require_relative "remote/remote"
require_relative "remote/denormalizer"
require_relative "remote/worker/fetcher"
