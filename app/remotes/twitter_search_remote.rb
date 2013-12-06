class TwitterSearchRemote
  include Remotus::Remote
  include Remotus::RemoteTwitter

  SEARCH_OPTIONS = {
    count: ENV["TWITTER_SEARCH_COUNT"].to_i,
    include_entities: false
  }
n
  def initialize(query, search_geolocation_id = nil, max = nil)
    @client = Remotus::RemoteTwitter.client

    unless search_geolocation_id.blank?
      @geolocation = Geolocation.find(search_geolocation_id)
      @georadius = ENV['SEARCH_RADIUS']
    end
    @options = SEARCH_OPTIONS.merge(geocode: "#{@geolocation.latitude},#{@geolocation.longitude},#{@georadius}km") if @geolocation.present?
    @options = SEARCH_OPTIONS.merge(max_id: max) if max
    begin
      if @geolocation.present?
        @results = @client.search(query, @options || SEARCH_OPTIONS).results
        warn("SearchQuery: #{query}, options: #{@options}, geocoded city: #{@geolocation.city}")
        warn("SearchResults: #{@results}")
      else
        warn("No geolocation specified")
      end
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
