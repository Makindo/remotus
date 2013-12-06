module Remotus
  module RemoteTwitterStream
   def self.client
     TweetStream::Client.new(
       :consumer_key => ENV["TWITTER_API_KEY"],
       :consumer_secret => ENV["TWITTER_API_SECRET"],
       :oauth_token => ENV["TWITTER_ACCESS_KEY"],
       :oauth_token_secret => ENV["TWITTER_ACCESS_SECRET"])
   end

   def self.daemon
     TweetStream.configure do |config| 
       config.consumer_key = ENV["TWITTER_API_KEY"]
       config.consumer_secret = ENV["TWITTER_API_SECRET"]
       config.oauth_token = ENV["TWITTER_ACCESS_KEY"]
       config.oauth_token_secret = ENV["TWITTER_ACCESS_SECRET"]
     end
     TweetStream::Daemon.new('twitter_stream', {multiple: true, ontop: true })
    end
  end
end
