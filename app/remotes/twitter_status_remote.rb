class TwitterStatusRemote
  include Remotus::Remote
  include Remotus::RemoteTwitter

  def initialize(query)
    @client = Remotus::RemoteTwitter.client
    begin
      @status = @client.status(query.to_i)
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      REDIS.sadd(self.class, query)
      warn("Twitter Status ##{query} can't be accessed.")
    rescue Twitter::Error::Unauthorized
      warn("Twitter client unauthorized.")
    rescue Twitter::Error::TooManyRequests => error
      warn("Twitter rate limit reached, next batch in #{error.rate_limit.reset_in} seconds")
      sleep(error.rate_limit.reset_in) and retry
    rescue Twitter::Error::InternalServerError
      warn("Twitter encountered an error: #{error}")
      sleep(15.seconds) and retry
    end

    @status ||= {}
  end

  def record
    TwitterStatusDenormalizer.new(@status).to_hash
  end
end
