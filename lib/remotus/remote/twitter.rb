module Remotus
  module RemoteTwitter
    def self.client
      Twitter::REST::Client.new(
        :consumer_key => ENV["TWITTER_API_KEY"],
        :consumer_secret => ENV["TWITTER_API_SECRET"],
        :auth_token => ENV["TWITTER_ACCESS_KEY"],
        :auth_token_secret => ENV["TWITTER_ACCESS_SECRET"])
    end
  end
end
