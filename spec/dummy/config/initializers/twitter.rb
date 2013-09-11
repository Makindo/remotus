module Twitter
  class Client
    private
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(builder: @middleware)) do |f|
        f.headers["Connection"] = ""
      end
    end
  end
end

Twitter.configure do |config|
  config.consumer_key = "bbUHiFMjFhOkhial9izPg"
  config.consumer_secret = "ZkQwJbOMohFJF7tZqQLhvtLuju7DPgzhOn0Rdz3xiw"
  config.oauth_token = "55137522-Q1ihDmuaxkdYKxQaAjaQ8Z6ljo3lUPLP9gLhZo7Q1"
  config.oauth_token_secret = "Tt7YtdPft8PgyDH2E2KwFrU6MEInj6mCLreh1q43w"
end
