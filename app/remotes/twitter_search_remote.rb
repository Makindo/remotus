class TwitterSearchRemote
  include Remotus::Remote
  include Remotus::RemoteTwitter

  SEARCH_OPTIONS = {
    count: ENV["TWITTER_SEARCH_COUNT"].to_i,
    include_entities: false
  }

  def initialize(query, search_geolocation_id = nil, max = nil)
    @client = Remotus::RemoteTwitter.client
    @options = SEARCH_OPTIONS.merge(max_id: max) if max

    unless search_geolocation_id.blank?
      @geolocation = Geolocation.find(search_geolocation_id)
      @longitude = @geolocation.longitude
      @latitude = @geolocation.latitude
      @georadius = ENV['SEARCH_RADIUS']
    else
      @longitude = 39.8
      @latitude = -95.583068847656
      @georadius = 2500
    end
    SEARCH_OPTIONS.merge(geocode: "#{@longitude},#{@latitude},#{@georadius}km")

    begin
      @results = @client.search(query, @options || SEARCH_OPTIONS).results
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
