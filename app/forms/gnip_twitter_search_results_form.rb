class GnipTwitterSearchResultsForm
  attr_reader :status
  attr_reader :profile
  attr_reader :search

  def initialize(status, search_id)
    @search = Search.find(search_id)
    @result = status.deep_symbolize_keys!
    @denorm = GnipTwitterDenormalizer.new(@result).to_hash
    @status = twitter_status
    @profile = twitter_profile
  end

  def valid?
    @status.valid? && @profile.valid? && close_geolocation
  end

  def close_geolocation
    @status.geocode
    close_enough = catch(:close_enough) do
      @search.account.geolocations.each do |geo| 
        geo_distance = @status.distance_to("#{geo.city}, #{geo.state}") || 1/0.0
        warch "geo_distance could not be computed" if geo_distance == 1/0.0
        if geo_distance < geo.radius
          throw(:close_enough, true)
        end
      end
      false
    end
    close_enough
  end

  def save
    @status.profile = @profile
    @profile.statses << @status
    @search.statuses << @status
    @status.save
    @profile.save
    @search.save
  end

  def twitter_status
    TwitterStatus.find_by_external_id(@denorm[:status][:external_id]) || TwitterStatus.new(@denorm[:status])
  end

  def twitter_profile
    TwitterProfile.find_by_external_id(@denorm[:profile][:external_id]) || TwitterProfile.new(@denorm[:profile])
  end
end
