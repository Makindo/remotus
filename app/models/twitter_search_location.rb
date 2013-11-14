class TwitterSearchLocation < Geolocation
  PROVIDER = "twitter_search"
  def self.clone_geo(geolocation)
    new_geo = TwitterSearchLocation.new
    new_geo.update_from_geocoder_result(geolocation)
    new_geo
  end
end
