class TwitterTimelineRemote
  include Remotus::Remote
  include Remotus::Twitter

  SEARCH_OPTIONS = {
    count: ENV["TWITTER_TIMELINE_COUNT"].to_i,
    contributor_details: false,
    include_rts: false
  }

  def initialize(query)
    begin
      @timeline = client.user_timeline(query.to_i, SEARCH_OPTIONS)
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      warn("Twitter Status ##{query} can't be accessed.")
      REDIS.sadd(self.class, query)
    rescue Twitter::Error::Unauthorized
      warn("Twitter client unauthorized.")
    rescue Twitter::Error::TooManyRequests => error
      warn("Twitter rate limit reached, next batch in #{error.rate_limit.reset_in} seconds")
      sleep(error.rate_limit.reset_in) and retry
    rescue Twitter::Error::InternalServerError
      warn("Twitter encountered an error: #{error}")
      sleep(15.seconds) and retry
    end

    @timeline ||= []
  end

  def records
    @timeline.map { |status| TwitterStatusDenormalizer.new(status).to_hash }
  end
end
