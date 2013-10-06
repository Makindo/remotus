class TwitterSearchRemote
  include Remotus::Remote
  include Remotus::Twitter

  SEARCH_OPTIONS = {
    count: ENV["TWITTER_SEARCH_COUNT"].to_i,
    geocode: "39.8,-95.583068847656,2500km",
    include_entities: false
  }

  def initialize(query, max = nil)
    @options = SEARCH_OPTIONS.merge(max_id: max) if max

    begin
      @results = client.search(query, @options || SEARCH_OPTIONS).results
    rescue Twitter::Error::Unauthorized
      warn("Twitter client unauthorized.")
    rescue Twitter::Error::TooManyRequests => error
      warn("Twitter rate limit reached, next batch in #{error.rate_limit.reset_in} seconds")
      sleep(error.rate_limit.reset_in) and retry
    rescue Twitter::Error::InternalServerError
      warn("Twitter encountered an error: #{error}")
      sleep(15.seconds) and retry
    end

    @results ||= []
  end

  def records
    @results.map { |status| TwitterSearchDenormalizer.new(status).to_hash }
  end
end

