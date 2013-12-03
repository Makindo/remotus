module Remotus
  module RemoteTwitterStream
   def self.client
     TweetStream::Client.new(
       :consumer_key => ENV["TWITTER_API_KEY"],
       :consumer_secret => ENV["TWITTER_API_SECRET"],
       :oauth_token => ENV["TWITTER_ACCESS_KEY"],
       :oauth_token_secret => ENV["TWITTER_ACCESS_SECRET"])
   end
  end
end
