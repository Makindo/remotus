module Remotus
  module Remote
    private

    def warn(message)
      Rails.logger.warn(message)
    end
  end
end

require_relative "remote/twitter"
require_relative "remote/twitter_stream"
require_relative "remote/facebook"
require_relative "remote/gnip"
