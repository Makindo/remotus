module Remotus
  module RemoteFacebook
    def self.client(options = {})
      @oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_API_KEY"], ENV["FACEBOOK_API_SECRET"], options)
      Koala::Facebook::API.new(@oauth.get_app_access_token)
    end
  end
end
