class TwitterProfileRemote
  include Remotus::Remote

  SEARCH_OPTIONS = {
    count: ENV["TWITTER_TIMELINE_COUNT"].to_i,
    contributor_details: false,
    include_rts: false
  }

  def initialize(query)
    begin
      @profile = Twitter.user(query.to_i, SEARCH_OPTIONS)
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

    @profile ||= {}
  end

  def record
    TwitterProfileDenormalizer.new(@profile).to_hash
  end
end
