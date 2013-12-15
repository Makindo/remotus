module Remotus
  module RemoteFacebook
    def self.client
      @oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_API_KEY"], ENV["FACEBOOK_API_SECRET"] )
      Koala::Facebook::API.new(@oauth.get_app_access_token)
    end
  end
end
